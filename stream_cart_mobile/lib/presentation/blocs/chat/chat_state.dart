import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_message_entity.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final List<ChatEntity> chatRooms;
  final bool hasReachedMax;
  final String? chatRoomId;
  final bool hasUnreadMessages;

  const ChatLoaded({
    this.messages = const [],
    this.chatRooms = const [],
    this.hasReachedMax = false,
    this.chatRoomId,
    this.hasUnreadMessages = false,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    List<ChatEntity>? chatRooms,
    bool? hasReachedMax,
    String? chatRoomId,
    bool? hasUnreadMessages,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      chatRooms: chatRooms ?? this.chatRooms,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
    );
  }

  @override
  List<Object?> get props => [messages, chatRooms, hasReachedMax, chatRoomId];
}

class ChatRoomsLoaded extends ChatState {
  final List<ChatEntity> chatRooms;
  final int totalUnreadCount;

  const ChatRoomsLoaded({this.chatRooms = const [], this.totalUnreadCount = 0});
  ChatRoomsLoaded copyWith({
    List<ChatEntity>? chatRooms,
    int? totalUnreadCount,
  }) {
    return ChatRoomsLoaded(
      chatRooms: chatRooms ?? this.chatRooms,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
    );
  }

  @override
  List<Object?> get props => [chatRooms, totalUnreadCount];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class LiveKitConnected extends ChatState {
  final String chatRoomId;

  const LiveKitConnected(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

class LiveKitDisconnected extends ChatState {}

class ChatStatusChanged extends ChatState {
  final String status;
  const ChatStatusChanged(this.status);
  
  @override
  List<Object?> get props => [status];
}

class ChatReconnecting extends ChatState {
  final String message;
  const ChatReconnecting(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ChatReconnectFailed extends ChatState {
  final String message;
  const ChatReconnectFailed(this.message);
  
  @override
  List<Object?> get props => [message];
}