import 'package:equatable/equatable.dart';

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

class LiveKitRoomEventReceived extends LiveStreamEvent {
	final Object roomEvent; // Will narrow in bloc using type checks
	const LiveKitRoomEventReceived(this.roomEvent);
	@override
	List<Object?> get props => [roomEvent];
}
