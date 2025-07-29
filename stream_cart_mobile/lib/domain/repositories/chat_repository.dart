import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import '../entities/chat_entity.dart';
import '../../core/error/failures.dart';

abstract class ChatRepository {
  /// Retrieves a list of chat rooms based on pagination and optional filter.
  /// 
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// [isActive]: Optional filter to get only active rooms (default: null).
  /// Returns [Either<Failure, List<ChatEntity>>] containing the result or failure.
  Future<Either<Failure, List<ChatEntity>>> getChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });

  /// Retrieves a list of messages for a specific chat room based on pagination.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 50).
  /// Returns [Either<Failure, List<ChatEntity>>] containing the result or failure.
  Future<Either<Failure, List<ChatMessage>>> getChatRoomMessages(
    String chatRoomId, {
    int pageNumber = 1,
    int pageSize = 50,
  });

  /// Marks a chat room as read.
  /// 
  /// [chatRoomId]: The ID of the chat room to mark as read.
  /// Returns [Either<Failure, void>] indicating success or failure.
  Future<Either<Failure, void>> markChatRoomAsRead(String chatRoomId);

  /// Retrieves a list of chat rooms associated with a specific shop based on pagination.
  /// 
  /// [shopId]: The ID of the shop.
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// Returns [Either<Failure, List<ChatEntity>>] containing the result or failure.
  Future<Either<Failure, List<ChatEntity>>> getChatRoomsByShop(String shopId, {
    int pageNumber = 1,
    int pageSize = 20,
  });

  /// Creates a new chat room with the given parameters.
  /// 
  /// [shopId]: The ID of the shop to create the chat room for.
  /// [relatedOrderId]: Optional ID of the related order (default: null).
  /// [initialMessage]: The initial message for the chat room.
  /// Returns [Either<Failure, ChatEntity>] containing the created chat room or failure.
  Future<Either<Failure, ChatEntity>> createChatRoom({
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
  /// Returns [Either<Failure, ChatEntity>] containing the sent message or failure.
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'Text',
    String? attachmentUrl,
  });

  /// Retrieves the shop token for a specific chat room to use with LiveKit.
  /// 
  /// [chatRoomId]: The ID of the chat room.
  /// [userId]: The ID of the user requesting the token (optional).
  /// [timestamp]: Timestamp to ensure unique identity (optional).
  /// Returns [Either<Failure, String>] containing the token or failure.
  Future<Either<Failure, String>> getShopToken(
    String chatRoomId, {
    String? userId,
    int? timestamp,
  });

  /// Retrieves a list of chat rooms associated with a specific shop based on pagination.
  /// 
  /// [pageNumber]: The page number to retrieve (default: 1).
  /// [pageSize]: The number of items per page (default: 20).
  /// [isActive]: Optional filter to get only active rooms (default: null).
  /// Returns [Either<Failure, List<ChatEntity>>] containing the result or failure.
  Future<Either<Failure, List<ChatEntity>>> getShopChatRooms({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isActive,
  });
}