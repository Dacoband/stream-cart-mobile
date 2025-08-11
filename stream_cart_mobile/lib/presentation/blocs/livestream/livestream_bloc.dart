import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../domain/usecases/livestream/get_livestream_usecase.dart';
import '../../../domain/usecases/livestream/join_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_livestreams_by_shop_usecase.dart';
import '../../../domain/usecases/livestream/get_products_by_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_active_livestreams_usecase.dart';
import '../../../domain/usecases/livestream/join_chat_livestream_usecase.dart';
import 'livestream_event.dart';
import 'livestream_state.dart';
import '../../../core/services/livekit_service.dart';
import '../../../core/config/livekit_config.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
	final GetLiveStreamUseCase getLiveStreamUseCase;
	final JoinLiveStreamUseCase joinLiveStreamUseCase;
	final GetLiveStreamsByShopUseCase getLiveStreamsByShopUseCase;
	final GetProductsByLiveStreamUseCase getProductsByLiveStreamUseCase;
	final JoinChatLiveStreamUseCase joinChatLiveStreamUseCase;
  final LiveKitService liveKitService;
	final GetActiveLiveStreamsUseCase? getActiveLiveStreamsUseCase;

	StreamSubscription<RoomEvent>? _roomSub;
	Timer? _primaryProbeTimer;

	LiveStreamBloc({
		required this.getLiveStreamUseCase,
		required this.joinLiveStreamUseCase,
		required this.getLiveStreamsByShopUseCase,
		required this.getProductsByLiveStreamUseCase,
		required this.joinChatLiveStreamUseCase,
    required this.liveKitService,
	this.getActiveLiveStreamsUseCase,
	}) : super(LiveStreamInitial()) {
		on<LoadLiveStreamEvent>(_onLoadLiveStream);
		on<JoinLiveStreamEvent>(_onJoinLiveStream);
		on<LoadLiveStreamsByShopEvent>(_onLoadLiveStreamsByShop);
	on<LoadActiveLiveStreamsEvent>(_onLoadActiveLiveStreams);
		on<LoadProductsByLiveStreamEvent>(_onLoadProductsByLiveStream);
		on<JoinChatLiveStreamEvent>(_onJoinChatLiveStream);
		on<RefreshLiveStreamEvent>(_onRefreshLiveStream);
    on<ConnectLiveKitEvent>(_onConnectLiveKit);
    on<DisconnectLiveKitEvent>(_onDisconnectLiveKit);
    on<LiveKitRoomEventReceived>(_onLiveKitRoomEventReceived);
	}

	Future<void> _onLoadLiveStream(LoadLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
		emit(LiveStreamLoading());
		final result = await getLiveStreamUseCase(event.id);
		result.fold(
			(failure) => emit(LiveStreamError(failure.message)),
			(liveStream) => emit(LiveStreamLoaded(liveStream: liveStream)),
		);
	}

	Future<void> _onJoinLiveStream(JoinLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is LiveStreamLoaded) {
			emit(currentState.copyWith(isJoining: true));
		} else {
			emit(LiveStreamLoading());
		}
		final result = await joinLiveStreamUseCase(event.id);
		result.fold(
			(failure) {
				if (state is LiveStreamLoaded) {
					emit((state as LiveStreamLoaded).copyWith(isJoining: false));
				} else {
					emit(LiveStreamError(failure.message));
				}
			},
			(liveStream) {
				if (state is LiveStreamLoaded) {
					emit((state as LiveStreamLoaded).copyWith(liveStream: liveStream, isJoining: false));
				} else {
					emit(LiveStreamLoaded(liveStream: liveStream));
				}
				if (liveStream.joinToken != null && liveStream.livekitRoomId != null) {
					final effectiveUrl = LiveKitConfig.serverUrl;
					add(ConnectLiveKitEvent(url: effectiveUrl, token: liveStream.joinToken!));
				} else {
				}
			},
		);
	}

	Future<void> _onLoadLiveStreamsByShop(LoadLiveStreamsByShopEvent event, Emitter<LiveStreamState> emit) async {
		emit(LiveStreamListLoading());
		final result = await getLiveStreamsByShopUseCase(event.shopId);
		result.fold(
			(failure) => emit(LiveStreamListError(failure.message)),
			(liveStreams) => emit(LiveStreamListLoaded(liveStreams)),
		);
	}

	Future<void> _onLoadActiveLiveStreams(LoadActiveLiveStreamsEvent event, Emitter<LiveStreamState> emit) async {
		final usecase = getActiveLiveStreamsUseCase;
		if (usecase == null) return;
		emit(LiveStreamListLoading());
		final result = await usecase.call(promotedOnly: event.promotedOnly);
		result.fold(
			(failure) => emit(LiveStreamListError(failure.message)),
			(liveStreams) => emit(LiveStreamListLoaded(liveStreams)),
		);
	}

	Future<void> _onLoadProductsByLiveStream(LoadProductsByLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is LiveStreamLoaded) {
			emit(currentState.copyWith(isLoadingProducts: true));
			final result = await getProductsByLiveStreamUseCase(event.liveStreamId);
			result.fold(
				(failure) => emit(currentState.copyWith(isLoadingProducts: false)),
				(products) => emit(currentState.copyWith(products: products, isLoadingProducts: false)),
			);
		}
	}

	Future<void> _onJoinChatLiveStream(JoinChatLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is LiveStreamLoaded) {
			final result = await joinChatLiveStreamUseCase(event.liveStreamId);
			result.fold(
				(failure) {},
				(messageEntity) {
					final updatedMessages = [...currentState.joinedMessages, messageEntity];
					emit(currentState.copyWith(joinedMessages: updatedMessages));
				},
			);
		}
	}

	Future<void> _onRefreshLiveStream(RefreshLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is LiveStreamLoaded) {
			emit(currentState.copyWith(isRefreshing: true));
			final result = await getLiveStreamUseCase(event.id);
			result.fold(
				(failure) => emit(currentState.copyWith(isRefreshing: false)),
				(liveStream) => emit(currentState.copyWith(liveStream: liveStream, isRefreshing: false)),
			);
		} else {
			add(LoadLiveStreamEvent(event.id));
		}
	}

	Future<void> _onConnectLiveKit(ConnectLiveKitEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		if (currentState.isConnectedRoom || currentState.isConnectingRoom) return;
		emit(currentState.copyWith(isConnectingRoom: true));
		try {
			await liveKitService.connect(url: event.url, token: event.token);
			_roomSub?.cancel();
			_roomSub = liveKitService.events.listen((e) { add(LiveKitRoomEventReceived(e)); });
			VideoTrack? primary;
			for (final p in liveKitService.remoteParticipants) {
				for (final pub in p.videoTrackPublications) {
					if (pub.track is VideoTrack) {
						primary = pub.track as VideoTrack;
						break;
					}
				}
				if (primary != null) break;
			}
			emit(currentState.copyWith(
				isConnectingRoom: false,
				isConnectedRoom: true,
				participants: liveKitService.remoteParticipants,
				primaryVideoTrack: primary ?? currentState.primaryVideoTrack,
			));
			// If still no primary track, probe after small delay (seller may publish slightly later)
			if (primary == null) {
				_primaryProbeTimer?.cancel();
				_primaryProbeTimer = Timer(const Duration(seconds: 2), () {
					final st = state;
					if (st is LiveStreamLoaded && st.primaryVideoTrack == null) {
						VideoTrack? latePrimary;
						for (final p in liveKitService.remoteParticipants) {
							for (final pub in p.videoTrackPublications) {
								if (pub.track is VideoTrack) { latePrimary = pub.track as VideoTrack; break; }
							}
							if (latePrimary != null) break;
						}
						if (latePrimary != null) {
							emit(st.copyWith(primaryVideoTrack: latePrimary, participants: liveKitService.remoteParticipants));
						}
					}
				});
			}
		} catch (e) {
			emit(currentState.copyWith(isConnectingRoom: false, isConnectedRoom: false));
		}
	}

	Future<void> _onDisconnectLiveKit(DisconnectLiveKitEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		await liveKitService.disconnect();
		await _roomSub?.cancel();
		emit(currentState.copyWith(isConnectedRoom: false, primaryVideoTrack: null, participants: []));
	}

	Future<void> _onLiveKitRoomEventReceived(LiveKitRoomEventReceived event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		final e = event.roomEvent;
		bool changed = false;
		VideoTrack? primary = currentState.primaryVideoTrack;

		if (e is TrackSubscribedEvent) {
			if (e.publication.track is VideoTrack) {
				primary = e.publication.track as VideoTrack;
				changed = true;
			}
		} else if (e is TrackUnsubscribedEvent) {
				if (primary != null && e.publication.sid == primary.sid) {
				primary = null;
				changed = true;
			}
		} else if (e is TrackPublishedEvent || e is ParticipantConnectedEvent) {
			// Try selecting a published video if we don't have one yet
			if (primary == null) {
				for (final p in liveKitService.remoteParticipants) {
					for (final pub in p.videoTrackPublications) {
						if (pub.track is VideoTrack) { primary = pub.track as VideoTrack; break; }
					}
					if (primary != null) break;
				}
				if (primary != null) changed = true;
			}
			changed = true;
		} else if (e is ParticipantDisconnectedEvent) {
			changed = true;
		} else if (e is RoomDisconnectedEvent) {
			emit(currentState.copyWith(isConnectedRoom: false, primaryVideoTrack: null, participants: []));
			return;
		}

		if (changed) {
			emit(currentState.copyWith(
				participants: liveKitService.remoteParticipants,
				primaryVideoTrack: primary,
			));
		}
	}

	@override
	Future<void> close() {
		_roomSub?.cancel();
		_primaryProbeTimer?.cancel();
		liveKitService.dispose();
		return super.close();
	}
}
