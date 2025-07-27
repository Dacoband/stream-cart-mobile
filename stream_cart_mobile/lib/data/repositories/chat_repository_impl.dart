import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import 'package:stream_cart_mobile/domain/repositories/chat_repository.dart';
import 'package:stream_cart_mobile/data/datasources/chat_remote_data_source.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import 'package:stream_cart_mobile/core/error/exceptions.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final chatRooms = await remoteDataSource.getChatRooms(
        pageNumber: pageNumber,
        pageSize: pageSize,
        isActive: isActive,
      );
      return Right(chatRooms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách phòng chat'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatRoomMessages(
    String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final messages = await remoteDataSource.getChatRoomMessages(
        chatRoomId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem tin nhắn'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Phòng chat không tồn tại'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markChatRoomAsRead(String chatRoomId) async {
    try {
      await remoteDataSource.markChatRoomAsRead(chatRoomId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để đánh dấu đã đọc'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Phòng chat không tồn tại'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getChatRoomsByShop(String shopId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final chatRooms = await remoteDataSource.getChatRoomsByShop(
        shopId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      ); // Giả định remoteDataSource có phương thức này
      return Right(chatRooms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem phòng chat của shop'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Shop không tồn tại'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createChatRoom({
    required String shopId,
    String? relatedOrderId,
    required String initialMessage,
  }) async {
    try {
      final chatRoom = await remoteDataSource.createChatRoom(
        shopId: shopId,
        relatedOrderId: relatedOrderId,
        initialMessage: initialMessage,
      );
      return Right(chatRoom);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để tạo phòng chat'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        chatRoomId: chatRoomId,
        content: content,
        messageType: messageType,
        attachmentUrl: attachmentUrl,
      );
      return Right(message);
    } on ServerException catch (e) {
      if (e.message.contains('Vui lòng đăng nhập')) {
        return Left(UnauthorizedFailure(e.message));
      } else if (e.message.contains('Yêu cầu không hợp lệ') ||
          e.message.contains('không thành công')) {
        return Left(ServerFailure(e.message));
      } else if (e.message.contains('Phòng chat không tồn tại')) {
        return Left(ServerFailure(e.message));
      } else if (e.message.contains('Lỗi máy chủ nội bộ')) {
        return Left(ServerFailure(e.message));
      } else if (e.message.contains('Kết nối timeout')) {
        return Left(NetworkFailure(e.message));
      }
      return Left(ServerFailure(e.message)); // Xử lý lỗi chung
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getShopToken(String chatRoomId) async {
    try {
      final token = await remoteDataSource.getShopToken(chatRoomId);
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để lấy token'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Phòng chat không tồn tại'));
      } else if (e.response?.statusCode == 500) {
        return Left(ServerFailure('Lỗi máy chủ nội bộ'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(NetworkFailure('Kết nối timeout'));
      }
      return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }
}