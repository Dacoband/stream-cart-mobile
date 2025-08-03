import 'package:dartz/dartz.dart';
import '../entities/chat/chat_message_entity.dart';
import '../entities/chat/chat_room_entity.dart';
import '../entities/chat/unread_count_entity.dart';
import '../../core/error/failures.dart';

abstract class ChatRepository {
  /// Retrieves a list of chat rooms based on pagination and optional filter.
  /// 
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// [isActive]: Optional filter to get only active rooms (default: null).
  /// Returns [Either<Failure, ChatRoomsPaginatedResponse>] containing the result or failure.
  Future<Either<Failure, ChatRoomsPaginatedResponse>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });

  /// Retrieves details of a specific chat room by its ID.
  /// 
  /// [chatRoomId]: The ID of the chat room to get details for.
  /// Returns [Either<Failure, ChatRoomEntity>] containing the chat room details or failure.
  Future<Either<Failure, ChatRoomEntity>> getChatRoomDetail(String chatRoomId);

  /// Retrieves a list of messages for a specific chat room based on pagination.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 50).
  /// Returns [Either<Failure, List<ChatMessage>>] containing the result or failure.
  Future<Either<Failure, List<ChatMessage>>> getChatRoomMessages(
    String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  });

  /// Search messages in a specific chat room.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [searchTerm]: The term to search for.
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// Returns [Either<Failure, List<ChatMessage>>] containing the result or failure.
  Future<Either<Failure, List<ChatMessage>>> searchChatRoomMessages(
    String chatRoomId, {
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 20,
  });

  /// Marks a chat room as read.
  /// 
  /// [chatRoomId]: The ID of the chat room to mark as read.
  /// Returns [Either<Failure, void>] indicating success or failure.
  Future<Either<Failure, void>> markChatRoomAsRead(String chatRoomId);

  /// Send typing indicator to a chat room.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [isTyping]: Whether user is typing or not.
  /// Returns [Either<Failure, void>] indicating success or failure.
  Future<Either<Failure, void>> sendTypingIndicator(String chatRoomId, bool isTyping);

  /// Creates a new chat room with the given parameters.
  /// 
  /// [shopId]: The ID of the shop to create the chat room for.
  /// [relatedOrderId]: Optional ID of the related order (default: null).
  /// [initialMessage]: The initial message for the chat room.
  /// Returns [Either<Failure, ChatRoomEntity>] containing the created chat room or failure.
  Future<Either<Failure, ChatRoomEntity>> createChatRoom({
    required String shopId,
    String? relatedOrderId,
    required String initialMessage,
  });

  /// Sends a message to a specific chat room.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [content]: The content of the message.
  /// [messageType]: The type of message (default: 'Text').
  /// [attachmentUrl]: Optional URL of an attachment (default: null).
  /// Returns [Either<Failure, ChatMessage>] containing the sent message or failure.
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  });

  /// Updates an existing message.
  /// 
  /// [messageId]: The ID of the message to update.
  /// [content]: The new content of the message.
  /// Returns [Either<Failure, ChatMessage>] containing the updated message or failure.
  Future<Either<Failure, ChatMessage>> updateMessage({
    required String messageId,
    required String content,
  });

  /// Get unread count for all chat rooms.
  /// 
  /// Returns [Either<Failure, UnreadCountEntity>] containing unread counts or failure.
  Future<Either<Failure, UnreadCountEntity>> getUnreadCount();

  /// Retrieves a list of chat rooms for shop (shop view).
  /// 
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// [isActive]: Optional filter to get only active rooms (default: null).
  /// Returns [Either<Failure, ChatRoomsPaginatedResponse>] containing the result or failure.
  Future<Either<Failure, ChatRoomsPaginatedResponse>> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });
}