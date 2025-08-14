import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/chatbot/chat_bot_entity.dart';
import '../../../domain/repositories/chatbot/chat_bot_repository.dart';
import '../../datasources/chatbot/chat_bot_remote_data_source.dart';

class ChatBotRepositoryImpl implements ChatBotRepository {
  final ChatBotRemoteDataSource remote;
  ChatBotRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, ChatBotHistoryEntity>> getHistory() async {
    try {
      final model = await remote.getHistory();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioToFailure(e, customNotFound: 'Không lấy được lịch sử Chat AI'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatBotMessageResponseEntity>> sendMessage({required String message}) async {
    try {
      final model = await remote.sendMessage(message);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioToFailure(e, customBadRequest: 'Gửi tin thất bại'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  Failure _mapDioToFailure(
    DioException e, {
    String? customBadRequest,
    String? customUnauthorized,
    String? customForbidden,
    String? customNotFound,
  }) {
    final status = e.response?.statusCode;
    final dataMessage = e.response?.data is Map<String, dynamic>
        ? e.response?.data['message'] as String?
        : null;
    switch (status) {
      case 400:
        return ServerFailure(customBadRequest ?? dataMessage ?? 'Yêu cầu không hợp lệ');
      case 401:
        return UnauthorizedFailure(customUnauthorized ?? 'Vui lòng đăng nhập');
      case 403:
        return ServerFailure(customForbidden ?? 'Không có quyền truy cập');
      case 404:
        return ServerFailure(customNotFound ?? 'Không tìm thấy dữ liệu');
      case 409:
        return ServerFailure(dataMessage ?? 'Xung đột dữ liệu');
      case 422:
        return ServerFailure(dataMessage ?? 'Không thể xử lý yêu cầu');
      default:
        return NetworkFailure('Lỗi kết nối: ${e.message}');
    }
  }
}
