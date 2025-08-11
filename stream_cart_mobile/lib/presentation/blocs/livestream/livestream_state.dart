import 'package:equatable/equatable.dart';
import '../../../domain/entities/livestream/livestream_entity.dart';
import '../../../domain/entities/livestream/livestream_product_entity.dart';
import '../../../domain/entities/livestream/livestream_message_entity.dart';

abstract class LiveStreamState extends Equatable {
	const LiveStreamState();

	@override
	List<Object?> get props => [];
}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamLoading extends LiveStreamState {}

class LiveStreamError extends LiveStreamState {
	final String message;
	const LiveStreamError(this.message);
	@override
	List<Object?> get props => [message];
}

class LiveStreamLoaded extends LiveStreamState {
	final LiveStreamEntity liveStream;
	final List<LiveStreamProductEntity> products;
	final List<LiveStreamChatMessageEntity> joinedMessages;
	final bool isJoining;
	final bool isLoadingProducts;
	final bool isRefreshing;

	const LiveStreamLoaded({
		required this.liveStream,
		this.products = const [],
		this.joinedMessages = const [],
		this.isJoining = false,
		this.isLoadingProducts = false,
		this.isRefreshing = false,
	});

	LiveStreamLoaded copyWith({
		LiveStreamEntity? liveStream,
		List<LiveStreamProductEntity>? products,
		List<LiveStreamChatMessageEntity>? joinedMessages,
		bool? isJoining,
		bool? isLoadingProducts,
		bool? isRefreshing,
	}) => LiveStreamLoaded(
				liveStream: liveStream ?? this.liveStream,
				products: products ?? this.products,
				joinedMessages: joinedMessages ?? this.joinedMessages,
				isJoining: isJoining ?? this.isJoining,
				isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
				isRefreshing: isRefreshing ?? this.isRefreshing,
			);

	@override
	List<Object?> get props => [
				liveStream,
				products,
				joinedMessages,
				isJoining,
				isLoadingProducts,
				isRefreshing,
			];
}

class LiveStreamListLoading extends LiveStreamState {}

class LiveStreamListLoaded extends LiveStreamState {
	final List<LiveStreamEntity> liveStreams;
	const LiveStreamListLoaded(this.liveStreams);
	@override
	List<Object?> get props => [liveStreams];
}

class LiveStreamListError extends LiveStreamState {
	final String message;
	const LiveStreamListError(this.message);
	@override
	List<Object?> get props => [message];
}
