import 'package:equatable/equatable.dart';
import '../../../domain/entities/livestream/livestream_entity.dart';
import '../../../domain/entities/livestream/livestream_product_entity.dart';
import '../../../domain/entities/livestream/livestream_message_entity.dart';
import 'package:livekit_client/livekit_client.dart' show VideoTrack, RemoteParticipant;

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
	final bool isConnectingRoom;
	final bool isConnectedRoom;
	final VideoTrack? primaryVideoTrack;
	final List<RemoteParticipant> participants;
	final int? viewerCount;
	final bool chatInitialized;

	const LiveStreamLoaded({
		required this.liveStream,
		this.products = const [],
		this.joinedMessages = const [],
		this.isJoining = false,
		this.isLoadingProducts = false,
		this.isRefreshing = false,
		this.isConnectingRoom = false,
		this.isConnectedRoom = false,
		this.primaryVideoTrack,
		this.participants = const [],
		this.viewerCount,
		this.chatInitialized = false,
	});

	LiveStreamLoaded copyWith({
		LiveStreamEntity? liveStream,
		List<LiveStreamProductEntity>? products,
		List<LiveStreamChatMessageEntity>? joinedMessages,
		bool? isJoining,
		bool? isLoadingProducts,
		bool? isRefreshing,
		bool? isConnectingRoom,
		bool? isConnectedRoom,
		VideoTrack? primaryVideoTrack,
		List<RemoteParticipant>? participants,
		int? viewerCount,
		bool? chatInitialized,
	}) => LiveStreamLoaded(
				liveStream: liveStream ?? this.liveStream,
				products: products ?? this.products,
				joinedMessages: joinedMessages ?? this.joinedMessages,
				isJoining: isJoining ?? this.isJoining,
				isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
				isRefreshing: isRefreshing ?? this.isRefreshing,
				isConnectingRoom: isConnectingRoom ?? this.isConnectingRoom,
				isConnectedRoom: isConnectedRoom ?? this.isConnectedRoom,
				primaryVideoTrack: primaryVideoTrack ?? this.primaryVideoTrack,
				participants: participants ?? this.participants,
				viewerCount: viewerCount ?? this.viewerCount,
				chatInitialized: chatInitialized ?? this.chatInitialized,
			);

	@override
	List<Object?> get props => [
				liveStream,
				products,
				joinedMessages,
				isJoining,
				isLoadingProducts,
				isRefreshing,
				isConnectingRoom,
				isConnectedRoom,
				primaryVideoTrack,
				participants,
				viewerCount,
				chatInitialized,
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
