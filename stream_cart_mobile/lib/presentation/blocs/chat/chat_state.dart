import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat/chat_message_entity.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../../domain/entities/chat/unread_count_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ChatInitial extends ChatState {}

// Loading States
class ChatLoading extends ChatState {}

class ChatRoomsLoading extends ChatState {}

class ChatMessagesLoading extends ChatState {}

class MessageSending extends ChatState {
  final String tempMessageId;
  final String content;

  const MessageSending({
    required this.tempMessageId,
    required this.content,
  });

  @override
  List<Object> get props => [tempMessageId, content];
}

// Success States
class ChatRoomsLoaded extends ChatState {
  final List<ChatRoomEntity> chatRooms;
  final int currentPage;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final int totalCount;
  final bool isRefresh;

  const ChatRoomsLoaded({
    required this.chatRooms,
    required this.currentPage,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.totalCount,
    this.isRefresh = false,
  });

  ChatRoomsLoaded copyWith({
    List<ChatRoomEntity>? chatRooms,
    int? currentPage,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    int? totalCount,
    bool? isRefresh,
  }) {
    return ChatRoomsLoaded(
      chatRooms: chatRooms ?? this.chatRooms,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      totalCount: totalCount ?? this.totalCount,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        chatRooms,
        currentPage,
        totalPages,
        hasNext,
        hasPrevious,
        totalCount,
        isRefresh,
      ];
}

class ChatRoomDetailLoaded extends ChatState {
  final ChatRoomEntity chatRoom;

  const ChatRoomDetailLoaded({required this.chatRoom});

  @override
  List<Object> get props => [chatRoom];
}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  final String chatRoomId;
  final int currentPage;
  final bool hasMoreMessages;
  final bool isRefresh;

  const ChatMessagesLoaded({
    required this.messages,
    required this.chatRoomId,
    required this.currentPage,
    required this.hasMoreMessages,
    this.isRefresh = false,
  });

  ChatMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    String? chatRoomId,
    int? currentPage,
    bool? hasMoreMessages,
    bool? isRefresh,
  }) {
    return ChatMessagesLoaded(
      messages: messages ?? this.messages,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      currentPage: currentPage ?? this.currentPage,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        chatRoomId,
        currentPage,
        hasMoreMessages,
        isRefresh,
      ];
}

class MessageSearchLoaded extends ChatState {
  final List<ChatMessage> searchResults;
  final String searchTerm;
  final String chatRoomId;
  final int currentPage;
  final bool hasMoreResults;

  const MessageSearchLoaded({
    required this.searchResults,
    required this.searchTerm,
    required this.chatRoomId,
    required this.currentPage,
    required this.hasMoreResults,
  });

  @override
  List<Object> get props => [
        searchResults,
        searchTerm,
        chatRoomId,
        currentPage,
        hasMoreResults,
      ];
}

class MessageSent extends ChatState {
  final ChatMessage message;

  const MessageSent({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageUpdated extends ChatState {
  final ChatMessage message;

  const MessageUpdated({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageReceived extends ChatState {
  final ChatMessage message;

  const MessageReceived({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatRoomCreated extends ChatState {
  final ChatRoomEntity chatRoom;

  const ChatRoomCreated({required this.chatRoom});

  @override
  List<Object> get props => [chatRoom];
}

class ChatRoomMarkedAsRead extends ChatState {
  final String chatRoomId;

  const ChatRoomMarkedAsRead({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

// Unread Count States
class UnreadCountLoaded extends ChatState {
  final UnreadCountEntity unreadCount;

  const UnreadCountLoaded({required this.unreadCount});

  @override
  List<Object> get props => [unreadCount];
}

class UnreadCountUpdated extends ChatState {
  final String chatRoomId;
  final int count;

  const UnreadCountUpdated({
    required this.chatRoomId,
    required this.count,
  });

  @override
  List<Object> get props => [chatRoomId, count];
}

// SignalR Connection States
class SignalRConnected extends ChatState {
  const SignalRConnected();
}

class SignalRDisconnected extends ChatState {
  final String? reason;

  const SignalRDisconnected({this.reason});

  @override
  List<Object?> get props => [reason];
}

class SignalRConnecting extends ChatState {
  const SignalRConnecting();
}

class SignalRReconnecting extends ChatState {
  const SignalRReconnecting();
}

class SignalRConnectionError extends ChatState {
  final String error;

  const SignalRConnectionError({required this.error});

  @override
  List<Object> get props => [error];
}

// Room Join/Leave States
class ChatRoomJoined extends ChatState {
  final String chatRoomId;

  const ChatRoomJoined({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

class ChatRoomLeft extends ChatState {
  final String chatRoomId;

  const ChatRoomLeft({required this.chatRoomId});

  @override
  List<Object> get props => [chatRoomId];
}

// Typing States
class TypingIndicatorSent extends ChatState {
  final String chatRoomId;
  final bool isTyping;

  const TypingIndicatorSent({
    required this.chatRoomId,
    required this.isTyping,
  });

  @override
  List<Object> get props => [chatRoomId, isTyping];
}

class UserTypingChanged extends ChatState {
  final String userId;
  final String chatRoomId;
  final bool isTyping;
  final String? userName;

  const UserTypingChanged({
    required this.userId,
    required this.chatRoomId,
    required this.isTyping,
    this.userName,
  });

  @override
  List<Object?> get props => [userId, chatRoomId, isTyping, userName];
}

// User Presence States
class UserJoinedRoom extends ChatState {
  final String userId;
  final String chatRoomId;
  final String? userName;

  const UserJoinedRoom({
    required this.userId,
    required this.chatRoomId,
    this.userName,
  });

  @override
  List<Object?> get props => [userId, chatRoomId, userName];
}

class UserLeftRoom extends ChatState {
  final String userId;
  final String chatRoomId;
  final String? userName;

  const UserLeftRoom({
    required this.userId,
    required this.chatRoomId,
    this.userName,
  });

  @override
  List<Object?> get props => [userId, chatRoomId, userName];
}

// Shop Chat States
class ShopChatRoomsLoaded extends ChatState {
  final List<ChatRoomEntity> chatRooms;
  final int currentPage;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final int totalCount;
  final bool isRefresh;

  const ShopChatRoomsLoaded({
    required this.chatRooms,
    required this.currentPage,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.totalCount,
    this.isRefresh = false,
  });

  ShopChatRoomsLoaded copyWith({
    List<ChatRoomEntity>? chatRooms,
    int? currentPage,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    int? totalCount,
    bool? isRefresh,
  }) {
    return ShopChatRoomsLoaded(
      chatRooms: chatRooms ?? this.chatRooms,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      totalCount: totalCount ?? this.totalCount,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        chatRooms,
        currentPage,
        totalPages,
        hasNext,
        hasPrevious,
        totalCount,
        isRefresh,
      ];
}

// Error States
class ChatError extends ChatState {
  final String message;
  final String? errorCode;

  const ChatError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class ChatRoomsError extends ChatState {
  final String message;

  const ChatRoomsError({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatMessagesError extends ChatState {
  final String message;
  final String chatRoomId;

  const ChatMessagesError({
    required this.message,
    required this.chatRoomId,
  });

  @override
  List<Object> get props => [message, chatRoomId];
}

class MessageSendError extends ChatState {
  final String message;
  final String tempMessageId;

  const MessageSendError({
    required this.message,
    required this.tempMessageId,
  });

  @override
  List<Object> get props => [message, tempMessageId];
}

class NetworkError extends ChatState {
  final String message;

  const NetworkError({required this.message});

  @override
  List<Object> get props => [message];
}

// Status States
class ChatStatusChanged extends ChatState {
  final String status;
  final String? details;

  const ChatStatusChanged({
    required this.status,
    this.details,
  });

  @override
  List<Object?> get props => [status, details];
}

// Clear/Reset States
class ChatStateCleared extends ChatState {
  const ChatStateCleared();
}

class MessagesCleared extends ChatState {
  const MessagesCleared();
}

class SearchResultsCleared extends ChatState {
  const SearchResultsCleared();
}