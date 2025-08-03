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
  final String? senderName; 
  final String? senderAvatarUrl;
  final bool isMine;

  const ChatMessage({
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
    this.senderName, 
    this.senderAvatarUrl,
    required this.isMine,
  });

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? senderUserId,
    String? content,
    DateTime? sentAt,
    bool? isRead,
    bool? isEdited,
    String? messageType,
    String? attachmentUrl,
    DateTime? editedAt,
    String? senderName,
    String? senderAvatarUrl,
    bool? isMine,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderUserId: senderUserId ?? this.senderUserId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      editedAt: editedAt ?? this.editedAt,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      isMine: isMine ?? this.isMine,
    );
  }

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