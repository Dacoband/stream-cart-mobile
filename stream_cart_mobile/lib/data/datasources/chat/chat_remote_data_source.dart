import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../../domain/entities/chat/chat_message_entity.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../../domain/entities/chat/unread_count_entity.dart';
import '../../models/chat/chat_room_model.dart';
import '../../models/chat/chat_message_model.dart';
import '../../models/chat/unread_count_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatRoomsPaginatedResponse> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });
  
  Future<ChatRoomEntity> getChatRoomDetail(String chatRoomId);
  
  Future<List<ChatMessage>> getChatRoomMessages(String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  });
  
  Future<List<ChatMessage>> searchChatRoomMessages(String chatRoomId, {
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  });
  
  Future<void> markChatRoomAsRead(String chatRoomId);
  
  Future<void> sendTypingIndicator(String chatRoomId, bool isTyping);
  
  Future<ChatRoomEntity> createChatRoom({
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
  
  Future<ChatMessage> updateMessage({
    required String messageId,
    required String content,
  });
  
  Future<UnreadCountEntity> getUnreadCount();
  
  Future<ChatRoomsPaginatedResponse> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<ChatRoomsPaginatedResponse> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.chatRoomEndpoint);
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (isActive != null) 'isActive': isActive,
      };

      final response = await dio.get(endpoint, queryParameters: queryParams);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'];
        final items = (data['items'] as List<dynamic>? ?? [])
            .map((json) => ChatRoomModel.fromJson(json))
            .map((model) => model.toEntity())
            .toList();
            
        return ChatRoomsPaginatedResponse(
          currentPage: data['currentPage'] ?? 0,
          pageSize: data['pageSize'] ?? 0,
          totalCount: data['totalCount'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          hasPrevious: data['hasPrevious'] ?? false,
          hasNext: data['hasNext'] ?? false,
          items: items,
        );
      } else {
        print('[DataSource] No chat rooms found');
        return const ChatRoomsPaginatedResponse(
          currentPage: 0,
          pageSize: 0,
          totalCount: 0,
          totalPages: 0,
          hasPrevious: false,
          hasNext: false,
          items: [],
        );
      }
    } catch (e) {
      print('[DataSource] Error getting chat rooms: $e');
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  @override
  Future<ChatRoomEntity> getChatRoomDetail(String chatRoomId) async {
    try {
      final url = ApiConstants.chatRoomDetailEndpoint.replaceAll('{chatRoomId}', chatRoomId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ChatRoomModel.fromJson(responseData['data']);
        return model.toEntity();
      } else {
        throw Exception('Chat room not found');
      }
    } catch (e) {
      print('[DataSource] Error getting chat room detail: $e');
      throw Exception('Failed to get chat room detail: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getChatRoomMessages(String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final url = ApiConstants.chatRoomMessagesEndpoint.replaceAll('{chatRoomId}', chatRoomId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      final response = await dio.get(endpoint, queryParameters: queryParams);
      final responseData = response.data;
      
      print('🔍 Chat room messages response: $responseData');
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;
        print('📋 Data structure: ${data.keys}');
        
        // Lấy items array từ data object
        final List<dynamic> messagesData = data['items'] as List<dynamic>;
        print('📨 Messages count: ${messagesData.length}');
        
        final models = messagesData.map((json) => ChatMessageModel.fromJson(json)).toList();
        final entities = models.map((model) => model.toEntity()).toList();
        
        print('✅ Messages parsed successfully: ${entities.length}');
        return entities;
      } else {
        print('[DataSource] No messages found for chat room: $chatRoomId');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error getting chat room messages: $e');
      throw Exception('Failed to get chat room messages: $e');
    }
  }

  @override
  Future<List<ChatMessage>> searchChatRoomMessages(String chatRoomId, {
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final url = ApiConstants.chatRoomMessagesSearchEndpoint.replaceAll('{chatRoomId}', chatRoomId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final queryParams = {
        'searchTerm': searchTerm,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };

      final response = await dio.get(endpoint, queryParameters: queryParams);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> messagesData = responseData['data'] as List<dynamic>;
        final models = messagesData.map((json) => ChatMessageModel.fromJson(json)).toList();
        final entities = models.map((model) => model.toEntity()).toList();
        return entities;
      } else {
        print('[DataSource] No messages found for search term: $searchTerm');
        return [];
      }
    } catch (e) {
      print('[DataSource] Error searching messages: $e');
      throw Exception('Failed to search messages: $e');
    }
  }

  @override
  Future<void> markChatRoomAsRead(String chatRoomId) async {
    try {
      final url = ApiConstants.chatRoomMarkReadEndpoint.replaceAll('{chatRoomId}', chatRoomId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      await dio.patch(endpoint);
    } catch (e) {
      print('[DataSource] Error marking chat room as read: $e');
      throw Exception('Failed to mark chat room as read: $e');
    }
  }

  @override
  Future<void> sendTypingIndicator(String chatRoomId, bool isTyping) async {
    try {
      final url = ApiConstants.chatRoomTypingEndpoint.replaceAll('{chatRoomId}', chatRoomId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final data = {'isTyping': isTyping};
      await dio.post(endpoint, data: data);
    } catch (e) {
      print('[DataSource] Error sending typing indicator: $e');
      throw Exception('Failed to send typing indicator: $e');
    }
  }

  @override
  Future<ChatRoomEntity> createChatRoom({
    required String shopId,
    String? relatedOrderId,
    required String initialMessage,
  }) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.chatRoomEndpoint);
      final data = {
        'shopId': shopId,
        if (relatedOrderId != null) 'relatedOrderId': relatedOrderId,
        'initialMessage': initialMessage,
      };

      final response = await dio.post(endpoint, data: data);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ChatRoomModel.fromJson(responseData['data']);
        return model.toEntity();
      } else {
        throw Exception('Failed to create chat room');
      }
    } catch (e) {
      print('[DataSource] Error creating chat room: $e');
      throw Exception('Failed to create chat room: $e');
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
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.chatMessagesEndpoint);
      final data = {
        'chatRoomId': chatRoomId,
        'content': content,
        'messageType': messageType,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      };

      final response = await dio.post(endpoint, data: data);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ChatMessageModel.fromJson(responseData['data']);
        return model.toEntity();
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('[DataSource] Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ChatMessage> updateMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final url = ApiConstants.chatMessagePutEndpoint.replaceAll('{messageId}', messageId);
      final endpoint = ApiUrlHelper.getEndpoint(url);
      final data = {'content': content};

      final response = await dio.put(endpoint, data: data);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = ChatMessageModel.fromJson(responseData['data']);
        return model.toEntity();
      } else {
        throw Exception('Failed to update message');
      }
    } catch (e) {
      print('[DataSource] Error updating message: $e');
      throw Exception('Failed to update message: $e');
    }
  }

  @override
  Future<UnreadCountEntity> getUnreadCount() async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.unReadCountEndpoint);
      final response = await dio.get(endpoint);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final model = UnreadCountModel.fromJson(responseData['data']);
        return model.toEntity();
      } else {
        print('[DataSource] No unread count data found');
        return const UnreadCountEntity(unreadCounts: {});
      }
    } catch (e) {
      print('[DataSource] Error getting unread count: $e');
      throw Exception('Failed to get unread count: $e');
    }
  }

  @override
  Future<ChatRoomsPaginatedResponse> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  }) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.chatShopRoomsEndpoint);
      final queryParams = {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (isActive != null) 'isActive': isActive,
      };

      final response = await dio.get(endpoint, queryParameters: queryParams);
      final responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'];
        final items = (data['items'] as List<dynamic>? ?? [])
            .map((json) => ChatRoomModel.fromJson(json))
            .map((model) => model.toEntity())
            .toList();
            
        return ChatRoomsPaginatedResponse(
          currentPage: data['currentPage'] ?? 0,
          pageSize: data['pageSize'] ?? 0,
          totalCount: data['totalCount'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          hasPrevious: data['hasPrevious'] ?? false,
          hasNext: data['hasNext'] ?? false,
          items: items,
        );
      } else {
        print('[DataSource] No shop chat rooms found');
        return const ChatRoomsPaginatedResponse(
          currentPage: 0,
          pageSize: 0,
          totalCount: 0,
          totalPages: 0,
          hasPrevious: false,
          hasNext: false,
          items: [],
        );
      }
    } catch (e) {
      print('[DataSource] Error getting shop chat rooms: $e');
      throw Exception('Failed to get shop chat rooms: $e');
    }
  }
}