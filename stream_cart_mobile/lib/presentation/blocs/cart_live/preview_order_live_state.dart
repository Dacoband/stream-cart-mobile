part of 'preview_order_live_bloc.dart';

abstract class PreviewOrderLiveState extends Equatable {
  const PreviewOrderLiveState();
  @override
  List<Object?> get props => [];
}

class PreviewOrderLiveInitial extends PreviewOrderLiveState {}

class PreviewOrderLiveLoading extends PreviewOrderLiveState {}

class PreviewOrderLiveRefreshing extends PreviewOrderLiveState {
  final PreviewOrderLiveEntity? previous;
  const PreviewOrderLiveRefreshing(this.previous);
  @override
  List<Object?> get props => [previous];
}

class PreviewOrderLiveLoaded extends PreviewOrderLiveState {
  final PreviewOrderLiveEntity data;
  const PreviewOrderLiveLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class PreviewOrderLiveEmpty extends PreviewOrderLiveState {}

class PreviewOrderLiveError extends PreviewOrderLiveState {
  final String message;
  const PreviewOrderLiveError(this.message);
  @override
  List<Object?> get props => [message];
}
