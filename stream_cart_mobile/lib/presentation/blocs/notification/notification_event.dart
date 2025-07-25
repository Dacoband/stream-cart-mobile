import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String? type;
  final bool? isRead;
  final int? pageIndex;
  final int? pageSize;
  final bool isRefresh;

  LoadNotifications({
    this.type,
    this.isRead,
    this.pageIndex,
    this.pageSize,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [type, isRead, pageIndex, pageSize, isRefresh];
}

class LoadMoreNotifications extends NotificationEvent {
  final String? type;
  final bool? isRead;
  final int pageIndex;
  final int pageSize;

  LoadMoreNotifications({
    this.type,
    this.isRead,
    required this.pageIndex,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [type, isRead, pageIndex, pageSize];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class LoadUnreadCount extends NotificationEvent {}

class RefreshNotifications extends NotificationEvent {
  final String? type;
  final bool? isRead;

  RefreshNotifications({this.type, this.isRead});

  @override
  List<Object?> get props => [type, isRead];
}

class NewNotificationReceived extends NotificationEvent {
  final String notificationJson;

  NewNotificationReceived(this.notificationJson);

  @override
  List<Object?> get props => [notificationJson];
}

class NotificationUpdated extends NotificationEvent {
  final String notificationId;
  final bool isRead;

  NotificationUpdated({
    required this.notificationId,
    required this.isRead,
  });

  @override
  List<Object?> get props => [notificationId, isRead];
}
