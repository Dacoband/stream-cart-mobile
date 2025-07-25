import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int totalItem;
  final int currentPage;
  final int pageSize;
  final bool hasMoreData;
  final int unreadCount;

  NotificationLoaded({
    required this.notifications,
    required this.totalItem,
    required this.currentPage,
    required this.pageSize,
    required this.hasMoreData,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        notifications,
        totalItem,
        currentPage,
        pageSize,
        hasMoreData,
        unreadCount,
      ];

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? totalItem,
    int? currentPage,
    int? pageSize,
    bool? hasMoreData,
    int? unreadCount,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      totalItem: totalItem ?? this.totalItem,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationLoadingMore extends NotificationState {
  final List<NotificationEntity> currentNotifications;
  final int unreadCount;

  NotificationLoadingMore({
    required this.currentNotifications,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [currentNotifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationMarkAsReadSuccess extends NotificationState {
  final String message;
  final String notificationId;

  NotificationMarkAsReadSuccess(this.message, this.notificationId);

  @override
  List<Object?> get props => [message, notificationId];
}

class UnreadCountLoaded extends NotificationState {
  final int count;

  UnreadCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}
