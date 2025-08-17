import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification/notification_entity.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationResponseEntity>> call(GetNotificationsParams params) async {
    return await repository.getNotifications(
      type: params.type,
      isRead: params.isRead,
      pageIndex: params.pageIndex,
      pageSize: params.pageSize,
    );
  }
}

class GetNotificationsParams {
  final String? type;
  final bool? isRead;
  final int? pageIndex;
  final int? pageSize;

  GetNotificationsParams({
    this.type,
    this.isRead,
    this.pageIndex,
    this.pageSize,
  });
}
