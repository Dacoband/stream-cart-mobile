import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatRoom extends ChatEvent {
  final String chatRoomId;

  const LoadChatRoom(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

class LoadChatRooms extends ChatEvent {
  final int pageNumber;
  final int pageSize;
  final bool? isActive;

  const LoadChatRooms({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.isActive,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, isActive];
}

class LoadShopChatRooms extends ChatEvent {
  final int pageNumber;
  final int pageSize;
  final bool? isActive;

  const LoadShopChatRooms({
    this.pageNumber = 1,
    this.pageSize = 20,
    this.isActive,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize, isActive];
}

class LoadChatRoomsByShop extends ChatEvent {
  final String shopId;
  final int pageNumber;
  final int pageSize;

  const LoadChatRoomsByShop({
    required this.shopId,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [shopId, pageNumber, pageSize];
}

class SendMessage extends ChatEvent {
  final String chatRoomId;
  final String message;
  final String messageType;
  final String? attachmentUrl;

  const SendMessage({
    required this.chatRoomId,
    required this.message,
    this.messageType = 'Text',
    this.attachmentUrl,
  });

  @override
  List<Object?> get props => [chatRoomId, message, messageType, attachmentUrl];
}

class ReceiveMessage extends ChatEvent {
  final String message;
  final String senderId;
  final String chatRoomId;
  final String senderName;
  final bool isMine;

  const ReceiveMessage(this.message, this.senderId, this.chatRoomId, this.senderName, this.isMine);

  @override
  List<Object?> get props => [message, senderId, chatRoomId, senderName, isMine];
}

class MarkChatRoomAsRead extends ChatEvent {
  final String chatRoomId;

  const MarkChatRoomAsRead(this.chatRoomId);

  @override
  List<Object?> get props => [chatRoomId];
}

class ConnectLiveKit extends ChatEvent {
  final String chatRoomId;
  final String userId;
  final String userName;

  const ConnectLiveKit({
    required this.chatRoomId,
    required this.userId,
    required this.userName,
  });

  @override
  List<Object?> get props => [chatRoomId, userId, userName];
}

class DisconnectLiveKit extends ChatEvent {
  const DisconnectLiveKit();

  @override
  List<Object?> get props => []; 
}

class ChatErrorEvent extends ChatEvent {
  final String message;
  const ChatErrorEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatLiveKitStatusChanged extends ChatEvent {
  final String status;
  const ChatLiveKitStatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}