import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<Either<Failure, NotificationResponseEntity>> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}
