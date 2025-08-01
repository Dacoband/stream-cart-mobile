import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class GetUnreadNotificationCountUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.getUnreadCount();
  }
}
