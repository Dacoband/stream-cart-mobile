import 'package:dio/dio.dart';
import 'package:stream_cart_mobile/core/constants/api_constants.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_entity.dart';
import '../models/chat_model.dart';
import '../../core/utils/api_url_helper.dart';
import '../../core/error/exceptions.dart'; 

abstract class ChatRemoteDataSource {
  Future<List<ChatEntity>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });

  Future<List<ChatMessage>> getChatRoomMessages(String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  });

  Future<void> markChatRoomAsRead(String chatRoomId);

  Future<ChatEntity> createChatRoom({
    required String shopId,
    String? relatedOrderId,
    required String initialMessage,
  });

  Future<ChatMessage> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  });
  Future<List<ChatEntity>> getChatRoomsByShop(
    String shopId, {
    int pageNumber = 1,
    int pageSize = 20,
  });
  Future<String> getShopToken(
    String chatRoomId, {
    String? userId,
    int? timestamp,
  }); 
  Future<List<ChatEntity>> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ChatEntity>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl(ApiConstants.chatRoomEndpoint);
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (isActive != null) 'isActive': isActive,
      };

      final response = await dio.get(url, queryParameters: queryParams);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      final data = responseData['data']['items'] as List<dynamic>? ?? [];
      return data.map((json) => ChatModel.fromJson(json).toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để xem danh sách phòng chat');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getChatRoomMessages(String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl(
          '${ApiConstants.chatRoomDetailsEndpoint.replaceFirst('{chatRoomId}', chatRoomId)}');
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      final response = await dio.get(url, queryParameters: queryParams);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      final data = responseData['data']['items'] as List<dynamic>? ?? [];
      return data.map((json) => LastMessageModel.fromJson(json).toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để xem tin nhắn');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Phòng chat không tồn tại');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> markChatRoomAsRead(String chatRoomId) async {
    try {
      final url = ApiUrlHelper.getFullUrl(
          '${ApiConstants.chatRoomMarkAsReadEndpoint.replaceFirst('{chatRoomId}', chatRoomId)}');
      final response = await dio.patch(url);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để đánh dấu đã đọc');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Phòng chat không tồn tại');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<ChatEntity> createChatRoom({
    required String shopId,
    String? relatedOrderId,
    required String initialMessage,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl(ApiConstants.chatRoomEndpoint);
      final requestData = {
        'shopId': shopId,
        if (relatedOrderId != null) 'relatedOrderId': relatedOrderId,
        'initialMessage': initialMessage,
      };

      final response = await dio.post(url, data: requestData);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      return ChatModel.fromJson(responseData['data']).toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để tạo phòng chat');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<ChatMessage> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl(ApiConstants.chatEndpoint);
      final requestData = {
        'chatRoomId': chatRoomId,
        'content': content,
        'messageType': messageType,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      };

      final response = await dio.post(url, data: requestData);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      return LastMessageModel.fromJson(responseData['data']).toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để gửi tin nhắn');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Phòng chat không tồn tại');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }


  @override
  Future<String> getShopToken(
    String chatRoomId, {
    String? userId,
    int? timestamp,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl(
          '${ApiConstants.shopTokenEndpoint.replaceFirst('{chatRoomId}', chatRoomId)}');
      
      // Add query parameters for better token generation
      final queryParams = <String, dynamic>{};
      if (userId != null) {
        queryParams['userId'] = userId;
      }
      if (timestamp != null) {
        queryParams['timestamp'] = timestamp;
      }
      
      print('getShopToken - Request URL: $url');
      print('getShopToken - Query params: $queryParams');
      print('getShopToken - Backend now supports both customer and shop accounts');
      
      final response = await dio.get(url, queryParameters: queryParams);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      return responseData['data']['shopToken'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để lấy token');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Phòng chat không tồn tại');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<List<ChatEntity>> getChatRoomsByShop(
    String shopId, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = ApiUrlHelper.getFullUrl('/api/chat/rooms/shop/$shopId');
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      final response = await dio.get(url, queryParameters: queryParams);
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
            errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công');
      }

      final data = responseData['data']['items'] as List<dynamic>? ?? [];
      return data.map((json) => ChatModel.fromJson(json).toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để xem phòng chat của shop');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Shop không tồn tại');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }

  @override
  Future<List<ChatEntity>> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.chatShopRoomsEndpoint,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          if (isActive != null) 'isActive': isActive,
        },
      );
      final responseData = response.data;
      if (responseData['success'] == false) {
        final errors = responseData['errors'] as List<dynamic>? ?? [];
        throw ServerException(
          errors.isNotEmpty ? errors.join(', ') : responseData['message'] ?? 'Yêu cầu không thành công'
        );
      }
      final items = responseData['data']['items'] as List<dynamic>? ?? [];
      return items.map((e) => ChatModel.fromJson(e).toEntity()).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Vui lòng đăng nhập để xem phòng chat của shop');
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        throw ServerException(responseData?['message'] ?? 'Yêu cầu không hợp lệ');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Lỗi máy chủ nội bộ');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Kết nối timeout');
      }
      throw ServerException('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định: $e');
    }
  }
}