import 'package:equatable/equatable.dart';
import '../../../domain/entities/livestream/livestream_message_entity.dart';

abstract class LiveStreamEvent extends Equatable {
	const LiveStreamEvent();

	@override
	List<Object?> get props => [];
}

class LoadLiveStreamEvent extends LiveStreamEvent {
	final String id;
	const LoadLiveStreamEvent(this.id);
	@override
	List<Object?> get props => [id];
}

class JoinLiveStreamEvent extends LiveStreamEvent {
	final String id;
	const JoinLiveStreamEvent(this.id);
	@override
	List<Object?> get props => [id];
}

class LoadLiveStreamsByShopEvent extends LiveStreamEvent {
	final String shopId;
	const LoadLiveStreamsByShopEvent(this.shopId);
	@override
	List<Object?> get props => [shopId];
}

class LoadProductsByLiveStreamEvent extends LiveStreamEvent {
	final String liveStreamId;
	const LoadProductsByLiveStreamEvent(this.liveStreamId);
	@override
	List<Object?> get props => [liveStreamId];
}

class JoinChatLiveStreamEvent extends LiveStreamEvent {
	final String liveStreamId;
	const JoinChatLiveStreamEvent(this.liveStreamId);
	@override
	List<Object?> get props => [liveStreamId];
}

class RefreshLiveStreamEvent extends LiveStreamEvent {
	final String id;
	const RefreshLiveStreamEvent(this.id);
	@override
	List<Object?> get props => [id];
}

class ConnectLiveKitEvent extends LiveStreamEvent {
	final String url;
	final String token;
	const ConnectLiveKitEvent({required this.url, required this.token});
	@override
	List<Object?> get props => [url, token];
}

class DisconnectLiveKitEvent extends LiveStreamEvent {
	const DisconnectLiveKitEvent();
}

class LoadActiveLiveStreamsEvent extends LiveStreamEvent {
	final bool? promotedOnly;
	const LoadActiveLiveStreamsEvent({this.promotedOnly});
	@override
	List<Object?> get props => [promotedOnly];
}

class LiveKitRoomEventReceived extends LiveStreamEvent {
	final Object roomEvent;
	const LiveKitRoomEventReceived(this.roomEvent);
	@override
	List<Object?> get props => [roomEvent];
}

class ViewerStatsReceived extends LiveStreamEvent {
	final int totalViewers;
	const ViewerStatsReceived(this.totalViewers);
	@override
	List<Object?> get props => [totalViewers];
}

class LoadLiveStreamMessagesEvent extends LiveStreamEvent {
	final String liveStreamId;
	const LoadLiveStreamMessagesEvent(this.liveStreamId);
	@override
	List<Object?> get props => [liveStreamId];
}

class SendLiveStreamMessageEvent extends LiveStreamEvent {
	final String liveStreamId;
	final String message;
	final int messageType;
	final String? replyToMessageId;
	const SendLiveStreamMessageEvent({
		required this.liveStreamId,
		required this.message,
		this.messageType = 0,
		this.replyToMessageId,
	});
	@override
	List<Object?> get props => [liveStreamId, message, messageType, replyToMessageId];
}

class LiveStreamMessageReceived extends LiveStreamEvent {
	final LiveStreamChatMessageEntity message;
	const LiveStreamMessageReceived(this.message);
	@override
	List<Object?> get props => [message];
}

class LiveKitPrimaryProbeTick extends LiveStreamEvent {
	LiveKitPrimaryProbeTick();
}
