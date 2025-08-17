import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/chat/chat_room_entity.dart';
import '../../domain/entities/chat/chat_message_entity.dart';
import '../../domain/entities/chat/unread_count_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat/chat_remote_data_source.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatRoomsPaginatedResponse>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final result = await remoteDataSource.getChatRooms(
        pageNumber: pageNumber,
        pageSize: pageSize,
        isActive: isActive,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi lấy danh sách phòng chat'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatRoomEntity>> getChatRoomDetail(String chatRoomId) async {
    try {
      final result = await remoteDataSource.getChatRoomDetail(chatRoomId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi lấy chi tiết phòng chat'));
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
      return Left(_handleDioException(e, 'Lỗi khi lấy tin nhắn'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> searchChatRoomMessages(
    String chatRoomId, {
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final messages = await remoteDataSource.searchChatRoomMessages(
        chatRoomId,
        searchTerm: searchTerm,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi tìm kiếm tin nhắn'));
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
      return Left(_handleDioException(e, 'Lỗi khi đánh dấu đã đọc'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendTypingIndicator(String chatRoomId, bool isTyping) async {
    try {
      await remoteDataSource.sendTypingIndicator(chatRoomId, isTyping);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi gửi trạng thái đang gõ'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatRoomEntity>> createChatRoom({
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
      return Left(_handleDioException(e, 'Lỗi khi tạo phòng chat'));
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
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi gửi tin nhắn'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> updateMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final message = await remoteDataSource.updateMessage(
        messageId: messageId,
        content: content,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi cập nhật tin nhắn'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UnreadCountEntity>> getUnreadCount() async {
    try {
      final unreadCount = await remoteDataSource.getUnreadCount();
      return Right(unreadCount);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi lấy số tin nhắn chưa đọc'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ChatRoomsPaginatedResponse>> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final result = await remoteDataSource.getShopChatRooms(
        pageNumber: pageNumber,
        pageSize: pageSize,
        isActive: isActive,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(_handleDioException(e, 'Lỗi khi lấy phòng chat của shop'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  // Helper method để xử lý DioException
  Failure _handleDioException(DioException e, String defaultMessage) {
    switch (e.response?.statusCode) {
      case 400:
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return ServerFailure(message);
      case 401:
        return UnauthorizedFailure('Vui lòng đăng nhập để tiếp tục');
      case 403:
        return UnauthorizedFailure('Bạn không có quyền thực hiện hành động này');
      case 404:
        return ServerFailure('Không tìm thấy dữ liệu');
      case 409:
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Dữ liệu bị xung đột';
        return ServerFailure(message);
      case 422:
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Dữ liệu không hợp lệ';
        return ValidationFailure(message);
      case 500:
        return ServerFailure('Lỗi máy chủ nội bộ');
      case 502:
        return ServerFailure('Lỗi kết nối máy chủ');
      case 503:
        return ServerFailure('Dịch vụ tạm thời không khả dụng');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return NetworkFailure('Kết nối timeout');
        } else if (e.type == DioExceptionType.connectionError) {
          return NetworkFailure('Lỗi kết nối mạng');
        } else if (e.type == DioExceptionType.cancel) {
          return NetworkFailure('Yêu cầu đã bị hủy');
        }
        return NetworkFailure('$defaultMessage: ${e.message}');
    }
  }
}