import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';

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

  const ChatLoaded({
    this.messages = const [],
    this.chatRooms = const [],
    this.hasReachedMax = false,
    this.chatRoomId,
  });

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    List<ChatEntity>? chatRooms,
    bool? hasReachedMax,
    String? chatRoomId,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      chatRooms: chatRooms ?? this.chatRooms,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  @override
  List<Object?> get props => [messages, chatRooms, hasReachedMax, chatRoomId];
}

class ChatRoomsLoaded extends ChatState {
  final List<ChatEntity> chatRooms;

  const ChatRoomsLoaded({this.chatRooms = const []});

  @override
  List<Object?> get props => [chatRooms];
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