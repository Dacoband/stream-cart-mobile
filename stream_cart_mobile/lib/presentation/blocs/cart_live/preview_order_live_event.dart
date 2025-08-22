part of 'preview_order_live_bloc.dart';

abstract class PreviewOrderLiveEvent extends Equatable {
  const PreviewOrderLiveEvent();
  @override
  List<Object?> get props => [];
}

class RequestPreviewOrderLiveEvent extends PreviewOrderLiveEvent {
  final List<String> cartItemIds;
  const RequestPreviewOrderLiveEvent(this.cartItemIds);
  @override
  List<Object?> get props => [cartItemIds];
}

class RefreshPreviewOrderLiveEvent extends PreviewOrderLiveEvent {
  final List<String> cartItemIds;
  const RefreshPreviewOrderLiveEvent(this.cartItemIds);
  @override
  List<Object?> get props => [cartItemIds];
}
