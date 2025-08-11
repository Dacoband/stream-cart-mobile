import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/livestream/get_livestream_usecase.dart';
import '../../../domain/usecases/livestream/join_livestream_usecase.dart';
import '../../../domain/usecases/livestream/get_livestreams_by_shop_usecase.dart';
import '../../../domain/usecases/livestream/get_products_by_livestream_usecase.dart';
import '../../../domain/usecases/livestream/join_chat_livestream_usecase.dart';
import 'livestream_event.dart';
import 'livestream_state.dart';

class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
	final GetLiveStreamUseCase getLiveStreamUseCase;
	final JoinLiveStreamUseCase joinLiveStreamUseCase;
	final GetLiveStreamsByShopUseCase getLiveStreamsByShopUseCase;
	final GetProductsByLiveStreamUseCase getProductsByLiveStreamUseCase;
	final JoinChatLiveStreamUseCase joinChatLiveStreamUseCase;

	LiveStreamBloc({
		required this.getLiveStreamUseCase,
		required this.joinLiveStreamUseCase,
		required this.getLiveStreamsByShopUseCase,
		required this.getProductsByLiveStreamUseCase,
		required this.joinChatLiveStreamUseCase,
	}) : super(LiveStreamInitial()) {
		on<LoadLiveStreamEvent>(_onLoadLiveStream);
		on<JoinLiveStreamEvent>(_onJoinLiveStream);
		on<LoadLiveStreamsByShopEvent>(_onLoadLiveStreamsByShop);
		on<LoadProductsByLiveStreamEvent>(_onLoadProductsByLiveStream);
		on<JoinChatLiveStreamEvent>(_onJoinChatLiveStream);
		on<RefreshLiveStreamEvent>(_onRefreshLiveStream);
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
}
