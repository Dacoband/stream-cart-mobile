import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../domain/usecases/livestream/get_livestream_usecase.dart';
import '../../../domain/usecases/livestream/join_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_livestreams_by_shop_usecase.dart';
import '../../../domain/usecases/livestream/get_products_by_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_pinned_products_by_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_active_livestreams_usecase.dart';
import '../../../domain/usecases/livestream/join_chat_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_livestream_messages_usecase.dart';
import '../../../domain/usecases/livestream/send_message_livestream_usecase.dart';
import 'livestream_event.dart';
import 'livestream_state.dart';
import '../../../core/services/livekit_service.dart';
import '../../../core/config/livekit_config.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/services/signalr_service.dart';
import '../../../domain/entities/livestream/livestream_message_entity.dart';
import '../../../domain/entities/livestream/livestream_product_entity.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_state.dart';
import '../../../domain/entities/account/account_entity.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
	final GetLiveStreamUseCase getLiveStreamUseCase;
	final JoinLiveStreamUseCase joinLiveStreamUseCase;
	final GetLiveStreamsByShopUseCase getLiveStreamsByShopUseCase;
	final GetProductsByLiveStreamUseCase getProductsByLiveStreamUseCase;
		final GetPinnedProductsByLiveStreamUseCase getPinnedProductsByLiveStreamUseCase;
	final JoinChatLiveStreamUseCase joinChatLiveStreamUseCase;
	final GetLiveStreamMessagesUseCase getLiveStreamMessagesUseCase;
	final SendMessageLiveStreamUseCase sendMessageLiveStreamUseCase;
  final LiveKitService liveKitService;
	final GetActiveLiveStreamsUseCase? getActiveLiveStreamsUseCase;

	StreamSubscription<RoomEvent>? _roomSub;
	Timer? _primaryProbeTimer;
	Timer? _productsReloadDebounce;
	DateTime? _lastProductsReloadAt;

	LiveStreamBloc({
		required this.getLiveStreamUseCase,
		required this.joinLiveStreamUseCase,
		required this.getLiveStreamsByShopUseCase,
		required this.getProductsByLiveStreamUseCase,
		required this.getPinnedProductsByLiveStreamUseCase,
		required this.joinChatLiveStreamUseCase,
	required this.getLiveStreamMessagesUseCase,
	required this.sendMessageLiveStreamUseCase,
    required this.liveKitService,
	this.getActiveLiveStreamsUseCase,
	}) : super(LiveStreamInitial()) {
		on<LoadLiveStreamEvent>(_onLoadLiveStream);
		on<JoinLiveStreamEvent>(_onJoinLiveStream);
		on<LoadLiveStreamsByShopEvent>(_onLoadLiveStreamsByShop);
	  on<LoadActiveLiveStreamsEvent>(_onLoadActiveLiveStreams);
		on<LoadProductsByLiveStreamEvent>(_onLoadProductsByLiveStream);
		on<LoadPinnedProductsByLiveStreamEvent>(_onLoadPinnedProductsByLiveStream);
		on<JoinChatLiveStreamEvent>(_onJoinChatLiveStream);
		on<LoadLiveStreamMessagesEvent>(_onLoadLiveStreamMessages);
		on<SendLiveStreamMessageEvent>(_onSendLiveStreamMessage);
		on<RefreshLiveStreamEvent>(_onRefreshLiveStream);
    on<ConnectLiveKitEvent>(_onConnectLiveKit);
    on<DisconnectLiveKitEvent>(_onDisconnectLiveKit);
    on<LiveKitRoomEventReceived>(_onLiveKitRoomEventReceived);
	on<ViewerStatsReceived>(_onViewerStatsReceived);
	on<LiveStreamMessageReceived>(_onLiveStreamMessageReceived);
	on<LiveKitPrimaryProbeTick>(_onPrimaryProbeTick);
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

		Future<void> _onLoadPinnedProductsByLiveStream(LoadPinnedProductsByLiveStreamEvent event, Emitter<LiveStreamState> emit) async {
			final currentState = state;
			if (currentState is LiveStreamLoaded) {
				emit(currentState.copyWith(isLoadingPinned: true));
				final result = await getPinnedProductsByLiveStreamUseCase(event.liveStreamId, limit: event.limit);
				result.fold(
					(failure) => emit(currentState.copyWith(isLoadingPinned: false)),
					(products) => emit(currentState.copyWith(pinnedProducts: products, isLoadingPinned: false)),
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
					final updated = [...currentState.joinedMessages];
					if (!updated.any((m) => m.id == messageEntity.id)) {
						updated.add(messageEntity);
					}
					emit(currentState.copyWith(joinedMessages: updated));
				},
			);
		}
	}

	Future<void> _onLoadLiveStreamMessages(LoadLiveStreamMessagesEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		final result = await getLiveStreamMessagesUseCase(event.liveStreamId);
		result.fold(
			(failure) {},
			(messages) {
				final sorted = [...messages]
					..sort((a, b) {
						final c = a.createdAt.compareTo(b.createdAt);
						if (c != 0) return c;
						return a.sentAt.compareTo(b.sentAt);
					});
				emit(currentState.copyWith(joinedMessages: sorted, chatInitialized: true));
			},
		);
	}

	Future<void> _onSendLiveStreamMessage(SendLiveStreamMessageEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
			final tempId = 'temp-${DateTime.now().microsecondsSinceEpoch}';
			final placeholder = LiveStreamChatMessageEntity(
				id: tempId,
				livestreamId: currentState.liveStream.id,
				senderId: 'me',
				senderName: 'Bạn',
				senderType: 'viewer',
				message: event.message,
				messageType: event.messageType,
				isModerated: false,
				sentAt: DateTime.now(),
				createdAt: DateTime.now(),
			);
			var optimistic = [...currentState.joinedMessages, placeholder];
			emit(currentState.copyWith(joinedMessages: optimistic));
			try {
				final s = getIt<SignalRService>();
				await s.sendLivestreamMessage(livestreamId: event.liveStreamId, message: event.message);
			} catch (_) {}

			final result = await sendMessageLiveStreamUseCase(
			livestreamId: event.liveStreamId,
			message: event.message,
			messageType: event.messageType,
			replyToMessageId: event.replyToMessageId,
		);
			result.fold(
				(failure) {
					final latest = state;
					if (latest is LiveStreamLoaded) {
						final removed = latest.joinedMessages.where((m) => m.id != tempId).toList();
						emit(latest.copyWith(joinedMessages: removed));
					}
				},
				(sent) async {
					final latest = state;
					if (latest is! LiveStreamLoaded) return;
					List<LiveStreamChatMessageEntity> updated = latest.joinedMessages
						.map((m) => m.id == tempId ? sent : m)
						.toList();
					if (!updated.any((m) => m.id == sent.id)) {
						updated.add(sent);
					}
					final seen = <String>{};
					updated = [
						for (final m in updated)
							if (seen.add(m.id)) m,
					];
					emit(latest.copyWith(joinedMessages: updated));
				},
			);
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
					try {
						final signalR = getIt<SignalRService>();
						await signalR.connect();
						final stJoin = state;
						final joinId = stJoin is LiveStreamLoaded ? stJoin.liveStream.id : currentState.liveStream.id;
						await signalR.joinLivestreamChat(joinId);
						await signalR.startViewingLivestream(joinId);
						signalR.onReceiveViewerStats = (stats) {
							final total = (stats['totalViewers'] as num?)?.toInt();
							if (total != null) add(ViewerStatsReceived(total));
						};
					signalR.onReceiveLivestreamMessage = (map) {
						try {
							final tsRaw = (map['timestamp'] ?? map['sentAt'] ?? map['createdAt'])?.toString();
							final parsedTs = tsRaw != null ? DateTime.tryParse(tsRaw) : null;
							final senderId = (map['senderId'] ?? '').toString();
							final rawId = (map['id'])?.toString();
							String genId;
							if (rawId != null && rawId.isNotEmpty) {
								genId = rawId;
							} else {
								final stableBase = '${(map['livestreamId'] ?? joinId).toString()}|$senderId|${(map['message'] ?? '').toString()}';
								genId = 'rt-${stableBase.hashCode}';
							}
							final entity = LiveStreamChatMessageEntity(
								id: genId,
								livestreamId: (map['livestreamId'] ?? joinId).toString(),
								senderId: senderId,
								senderName: (map['senderName'] ?? 'User').toString(),
								senderType: (map['senderType'] ?? '').toString(),
								message: (map['message'] ?? '').toString(),
								messageType: (map['messageType'] is int) ? map['messageType'] as int : int.tryParse('${map['messageType']}') ?? 0,
								replyToMessageId: (map['replyToMessageId'])?.toString(),
								isModerated: (map['isModerated'] == true),
								sentAt: parsedTs ?? DateTime.now(),
								createdAt: parsedTs ?? DateTime.now(),
								senderAvatarUrl: (map['senderAvatarUrl'])?.toString(),
								replyToMessage: (map['replyToMessage'])?.toString(),
								replyToSenderName: (map['replyToSenderName'])?.toString(),
							);
							add(LiveStreamMessageReceived(entity));
						} catch (_) {}
					};
									// --- Realtime products & pinned products ---
									String? _lsIdFrom(Map<String, dynamic> m) {
										final v = m['livestreamId'] ?? m['liveStreamId'] ?? m['LivestreamId'] ?? m['LiveStreamId'];
										return v?.toString();
									}
												void _maybeReloadProducts(Map<String, dynamic> payload) {
													final id = _lsIdFrom(payload) ?? joinId;
													if (id != joinId) return;
													final now = DateTime.now();
													if (_lastProductsReloadAt != null && now.difference(_lastProductsReloadAt!).inMilliseconds < 1200) return;
													_lastProductsReloadAt = now;
													_productsReloadDebounce?.cancel();
													_productsReloadDebounce = Timer(const Duration(milliseconds: 200), () {
														add(LoadProductsByLiveStreamEvent(joinId));
													});
												}
												// Apply pinned realtime without API reload
												void _applyPinnedRealtime(Map<String, dynamic> payload) {
													final id = _lsIdFrom(payload) ?? joinId;
													if (id != joinId) return;
													final current = state;
													if (current is! LiveStreamLoaded) return;
													final raw = payload['pinnedProducts'] ?? payload['products'] ?? payload['items'];
													if (raw is! List) return;
													List<LiveStreamProductEntity> mapped = [];
													for (final e in raw) {
														if (e is Map) {
															final m = e.cast<String, dynamic>();
															try {
																final created = () {
																	final ts = m['createdAt'] ?? m['timestamp'] ?? m['created_at'];
																	if (ts is String) { return DateTime.tryParse(ts) ?? DateTime.now(); }
																	return DateTime.now();
																}();
																final modified = () {
																	final ts = m['lastModifiedAt'] ?? m['updatedAt'] ?? m['modifiedAt'];
																	if (ts is String) { return DateTime.tryParse(ts) ?? created; }
																	return created;
																}();
																mapped.add(LiveStreamProductEntity(
																	id: (m['id'] ?? m['livestreamProductId'] ?? '').toString(),
																	livestreamId: (m['livestreamId'] ?? m['liveStreamId'] ?? joinId).toString(),
																	productId: (m['productId'] ?? '').toString(),
																	variantId: m['variantId']?.toString(),
																	flashSaleId: m['flashSaleId']?.toString(),
																	isPin: true,
																	originalPrice: ((m['originalPrice'] is num) ? m['originalPrice'] : num.tryParse('${m['originalPrice']}') ?? 0).toDouble(),
																	price: ((m['price'] is num) ? m['price'] : num.tryParse('${m['price']}') ?? 0).toDouble(),
																	stock: ((m['stock'] is num) ? m['stock'] : num.tryParse('${m['stock']}') ?? 0).toInt(),
																	productStock: ((m['productStock'] is num) ? m['productStock'] : num.tryParse('${m['productStock']}') ?? ((m['stock'] is num) ? m['stock'] : num.tryParse('${m['stock']}') ?? 0)).toInt(),
																	createdAt: created,
																	lastModifiedAt: modified,
																	sku: (m['sku'] ?? '').toString(),
																	productName: (m['productName'] ?? m['name'] ?? 'SP').toString(),
																	productImageUrl: (m['productImageUrl'] ?? m['imageUrl'] ?? '').toString(),
																	variantName: m['variantName']?.toString(),
																));
														} catch (_) {}
													}
													}
													final currIds = current.pinnedProducts.map((p)=>p.id).join(',');
													final newIds = mapped.map((p)=>p.id).join(',');
													if (currIds == newIds) return;
													emit(current.copyWith(pinnedProducts: mapped));
												}
												signalR.onPinnedProductsUpdated = (payload) { _applyPinnedRealtime(payload); };
									signalR.onProductAdded = (payload) { _maybeReloadProducts(payload); };
									signalR.onProductRemoved = (payload) { _maybeReloadProducts(payload); };
									signalR.onLivestreamProductUpdated = (payload) { _maybeReloadProducts(payload); };
												signalR.onProductPinStatusChanged = (payload) { _maybeReloadProducts(payload); _applyPinnedRealtime(payload); };
												signalR.onLivestreamProductPinStatusChanged = (payload) { _maybeReloadProducts(payload); _applyPinnedRealtime(payload); };
									signalR.onProductStockUpdated = (payload) { _maybeReloadProducts(payload); };
									signalR.onLivestreamProductStockUpdated = (payload) { _maybeReloadProducts(payload); };
									add(LoadProductsByLiveStreamEvent(joinId));
									// Single initial pinned fetch still okay; afterwards realtime updates manage state
									add(LoadPinnedProductsByLiveStreamEvent(joinId));
					} catch (_) {}
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
			final latest = state;
			if (latest is! LiveStreamLoaded) return;
			emit(latest.copyWith(
				isConnectingRoom: false,
				isConnectedRoom: true,
				participants: liveKitService.remoteParticipants,
				primaryVideoTrack: primary ?? latest.primaryVideoTrack,
			));
			if (primary == null) {
				_primaryProbeTimer?.cancel();
				_primaryProbeTimer = Timer(const Duration(seconds: 2), () { add(LiveKitPrimaryProbeTick()); });
			}
		} catch (e) {
			final latest = state;
			if (latest is LiveStreamLoaded) {
				emit(latest.copyWith(isConnectingRoom: false, isConnectedRoom: false));
			}
		}
	}

	Future<void> _onViewerStatsReceived(ViewerStatsReceived event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		emit(currentState.copyWith(viewerCount: event.totalViewers));
	}

	Future<void> _onDisconnectLiveKit(DisconnectLiveKitEvent event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;
		try { 
			final s = getIt<SignalRService>();
			s.onReceiveViewerStats = null; 
			s.onReceiveLivestreamMessage = null;
      s.onPinnedProductsUpdated = null;
      s.onProductAdded = null;
      s.onProductRemoved = null;
      s.onLivestreamProductUpdated = null;
      s.onProductPinStatusChanged = null;
      s.onLivestreamProductPinStatusChanged = null;
      s.onProductStockUpdated = null;
      s.onLivestreamProductStockUpdated = null;
        await s.leaveLivestreamChat(currentState.liveStream.id);
        try { await s.stopViewingLivestream(currentState.liveStream.id); } catch (_) {}
		} catch (_) {}
		await liveKitService.disconnect();
		await _roomSub?.cancel();
		_productsReloadDebounce?.cancel();
		emit(currentState.copyWith(isConnectedRoom: false, primaryVideoTrack: null, participants: []));
	}

	Future<void> _onLiveStreamMessageReceived(LiveStreamMessageReceived event, Emitter<LiveStreamState> emit) async {
		final currentState = state;
		if (currentState is! LiveStreamLoaded) return;

		// Skip own messages to avoid duplicates when sending
		final currentUser = _getCurrentUser();
		if (currentUser != null && currentUser.id == event.message.senderId) {
			return;
		}

		final updated = [...currentState.joinedMessages];
		if (!updated.any((m) => m.id == event.message.id)) {
			updated.add(event.message);
		}
		emit(currentState.copyWith(joinedMessages: updated));
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

	Future<void> _onPrimaryProbeTick(LiveKitPrimaryProbeTick event, Emitter<LiveStreamState> emit) async {
		final st = state;
		if (st is! LiveStreamLoaded || st.primaryVideoTrack != null) return;
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

	// Helper method to get current user
	AccountEntity? _getCurrentUser() {
		try {
			final authBloc = getIt<AuthBloc>();
			final authState = authBloc.state;
			if (authState is AuthSuccess) {
				return authState.loginResponse.account;
			}
			return null;
		} catch (e) {
			return null;
		}
	}

	@override
	Future<void> close() {
		_roomSub?.cancel();
		_primaryProbeTimer?.cancel();
		_productsReloadDebounce?.cancel();
		liveKitService.dispose();
		return super.close();
	}
}
