import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/notification/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification/notification_remote_data_source.dart';
import '../models/notification/notification_model.dart';
import '../../core/error/failures.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, NotificationResponseEntity>> getNotifications({
    String? type,
    bool? isRead,
    int? pageIndex,
    int? pageSize,
  }) async {
    try {
      final response = await remoteDataSource.getNotifications(
        type: type,
        isRead: isRead,
        pageIndex: pageIndex,
        pageSize: pageSize,
      );
      
      if (response.success) {
        final notificationListModel = response.data != null 
            ? NotificationListModel.fromJson(response.data)
            : const NotificationListModel(
                totalItem: 0,
                pageIndex: 1,
                pageCount: 0,
                notificationList: [],
              );
        final notificationResponseEntity = NotificationResponseEntity(
          success: response.success,
          message: response.message,
          data: notificationListModel.toEntity(),
          errors: response.errors,
        );
        return Right(notificationResponseEntity);
      } else {
        if (response.message == "Không tìm thấy thông báo") {
          final emptyNotificationResponseEntity = NotificationResponseEntity(
            success: true, 
            message: response.message,
            data: const NotificationListEntity(
              notificationList: [],
              totalItem: 0,
              pageIndex: 1,
              pageCount: 0,
            ),
            errors: response.errors,
          );
          return Right(emptyNotificationResponseEntity);
        } else {
          return Left(ServerFailure(response.message));
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Notifications not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getNotifications: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, NotificationResponseEntity>> markAsRead(String notificationId) async {
    try {
      final response = await remoteDataSource.markAsRead(notificationId);
      
      if (response.success) {
        return Right(response.toEntity());
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Notification not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in markAsRead: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final response = await remoteDataSource.getNotifications(
        isRead: false,
        pageIndex: 1,
        pageSize: 1000,
      );
      
      if (response.success) {
        final notificationListModel = response.data != null 
            ? NotificationListModel.fromJson(response.data)
            : const NotificationListModel(
                totalItem: 0,
                pageIndex: 1,
                pageCount: 0,
                notificationList: [],
              );
        return Right(notificationListModel.totalItem);
      } else {
        if (response.message == "Không tìm thấy thông báo") {
          return const Right(0);
        } else {
          return Left(ServerFailure(response.message));
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getUnreadCount: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
