import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Chat Room Events
class LoadChatRoomsEvent extends ChatEvent {
  final int pageNumber;
  final int pageSize;
  final bool? isActive;
  final bool isRefresh;

  const LoadChatRoomsEvent({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.isActive,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, isActive, isRefresh];
}

class LoadChatRoomDetailEvent extends ChatEvent {
  final String chatRoomId;

  const LoadChatRoomDetailEvent({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

class CreateChatRoomEvent extends ChatEvent {
  final String shopId;
  final String? relatedOrderId;
  final String initialMessage;

  const CreateChatRoomEvent({
    required this.shopId,
    this.relatedOrderId,
    required this.initialMessage,
  });

  @override
  List<Object?> get props => [shopId, relatedOrderId, initialMessage];
}

// Message Events
class LoadChatRoomMessagesEvent extends ChatEvent {
  final String chatRoomId;
  final int pageNumber;
  final int pageSize;
  final bool isRefresh;

  const LoadChatRoomMessagesEvent({
    required this.chatRoomId,
    this.pageNumber = 1,
    this.pageSize = 50,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [chatRoomId, pageNumber, pageSize, isRefresh];
}

class SearchChatRoomMessagesEvent extends ChatEvent {
  final String chatRoomId;
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  const SearchChatRoomMessagesEvent({
    required this.chatRoomId,
    required this.searchTerm,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [chatRoomId, searchTerm, pageNumber, pageSize];
}

class SendMessageEvent extends ChatEvent {
  final String chatRoomId;
  final String content;
  final String messageType;
  final String? attachmentUrl;

  const SendMessageEvent({
    required this.chatRoomId,
    required this.content,
    this.messageType = 'Text',
    this.attachmentUrl,
  });

  @override
  List<Object?> get props => [chatRoomId, content, messageType, attachmentUrl];
}

class UpdateMessageEvent extends ChatEvent {
  final String messageId;
  final String content;

  const UpdateMessageEvent({
    required this.messageId,
    required this.content,
  });

  @override
  List<Object> get props => [messageId, content];
}

class ReceiveMessageEvent extends ChatEvent {
  final Map<String, dynamic> messageData;

  const ReceiveMessageEvent({required this.messageData});

  @override
  List<Object> get props => [messageData];
}

// Chat Room Actions
class MarkChatRoomAsReadEvent extends ChatEvent {
  final String chatRoomId;

  const MarkChatRoomAsReadEvent({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

class JoinChatRoomEvent extends ChatEvent {
  final String chatRoomId;

  const JoinChatRoomEvent({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

class LeaveChatRoomEvent extends ChatEvent {
  final String chatRoomId;

  const LeaveChatRoomEvent({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

// Typing Events
class SendTypingIndicatorEvent extends ChatEvent {
  final String chatRoomId;
  final bool isTyping;

  const SendTypingIndicatorEvent({
    required this.chatRoomId,
    required this.isTyping,
  });

  @override
  List<Object> get props => [chatRoomId, isTyping];
}

class UserTypingChangedEvent extends ChatEvent {
  final String userId;
  final String chatRoomId;
  final bool isTyping;

  const UserTypingChangedEvent({
    required this.userId,
    required this.chatRoomId,
    required this.isTyping,
  });

  @override
  List<Object> get props => [userId, chatRoomId, isTyping];
}

// SignalR Connection Events
class ConnectSignalREvent extends ChatEvent {
  const ConnectSignalREvent();
}

class DisconnectSignalREvent extends ChatEvent {
  const DisconnectSignalREvent();
}

class SignalRConnectionChangedEvent extends ChatEvent {
  final bool isConnected;
  final String? error;

  const SignalRConnectionChangedEvent({
    required this.isConnected,
    this.error,
  });

  @override
  List<Object?> get props => [isConnected, error];
}

// Shop Events (for shop role 'seller')
class LoadShopChatRoomsEvent extends ChatEvent {
  final int pageNumber;
  final int pageSize;
  final bool? isActive;
  final bool isRefresh;

  const LoadShopChatRoomsEvent({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.isActive,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, isActive, isRefresh];
}

// Unread Count Events
class LoadUnreadCountEvent extends ChatEvent {
  const LoadUnreadCountEvent();
}

class UpdateUnreadCountEvent extends ChatEvent {
  final String chatRoomId;
  final int count;

  const UpdateUnreadCountEvent({
    required this.chatRoomId,
    required this.count,
  });

  @override
  List<Object> get props => [chatRoomId, count];
}

// User Presence Events
class UserJoinedRoomEvent extends ChatEvent {
  final String userId;
  final String chatRoomId;

  const UserJoinedRoomEvent({
    required this.userId,
    required this.chatRoomId,
  });

  @override
  List<Object> get props => [userId, chatRoomId];
}

class UserLeftRoomEvent extends ChatEvent {
  final String userId;
  final String chatRoomId;

  const UserLeftRoomEvent({
    required this.userId,
    required this.chatRoomId,
  });

  @override
  List<Object> get props => [userId, chatRoomId];
}

// Error Events
class ChatErrorEvent extends ChatEvent {
  final String error;

  const ChatErrorEvent({required this.error});

  @override
  List<Object> get props => [error];
}

// Reset/Clear Events
class ClearChatStateEvent extends ChatEvent {
  const ClearChatStateEvent();
}

class ClearMessagesEvent extends ChatEvent {
  const ClearMessagesEvent();
}

class ClearSearchResultsEvent extends ChatEvent {
  const ClearSearchResultsEvent();
}

class TypingReceivedEvent extends ChatEvent {
  final String userId;
  final String chatRoomId;
  final String? userName;
  final bool isTyping;
  final DateTime? timestamp;

  const TypingReceivedEvent({
    required this.userId,
    required this.chatRoomId,
    this.userName,
    required this.isTyping,
    this.timestamp,
  });

  @override
  List<Object?> get props => [userId, chatRoomId, userName, isTyping, timestamp];
}