import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String chatRoomId;
  final String senderUserId;
  final String content;
  final DateTime sentAt;
  final bool isRead;
  final bool isEdited;
  final String messageType;
  final String? attachmentUrl;
  final DateTime? editedAt;
  final String senderName;
  final String? senderAvatarUrl;
  final bool isMine;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderUserId,
    required this.content,
    required this.sentAt,
    required this.isRead,
    required this.isEdited,
    required this.messageType,
    this.attachmentUrl,
    this.editedAt,
    required this.senderName,
    this.senderAvatarUrl,
    required this.isMine,
  });

  @override
  List<Object?> get props => [
        id,
        chatRoomId,
        senderUserId,
        content,
        sentAt,
        isRead,
        isEdited,
        messageType,
        attachmentUrl,
        editedAt,
        senderName,
        senderAvatarUrl,
        isMine,
      ];
}