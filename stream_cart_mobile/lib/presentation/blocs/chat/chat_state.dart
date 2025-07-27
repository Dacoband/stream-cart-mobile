import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat_entity.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chatRooms;
  final List<ChatMessage> messages;
  final bool hasReachedMax;

  const ChatLoaded({
    this.chatRooms = const [],
    this.messages = const [],
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [chatRooms, messages, hasReachedMax];
}


class ChatRoomsLoaded extends ChatState {
  final List<ChatEntity> chatRooms;
  final bool hasReachedMax;

  const ChatRoomsLoaded({
    this.chatRooms = const [],
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [chatRooms, hasReachedMax];
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