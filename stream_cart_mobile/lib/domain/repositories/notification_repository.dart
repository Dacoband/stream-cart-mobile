import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification/notification_entity.dart';

abstract class NotificationRepository {
  /// Get notifications with pagination
  Future<Either<Failure, NotificationResponseEntity>> getNotifications({
    String? type,
    bool? isRead,
    int? pageIndex,
    int? pageSize,
  });

  /// Mark notification as read
  Future<Either<Failure, NotificationResponseEntity>> markAsRead(String notificationId);

  /// Get unread notification count
  Future<Either<Failure, int>> getUnreadCount();
}
