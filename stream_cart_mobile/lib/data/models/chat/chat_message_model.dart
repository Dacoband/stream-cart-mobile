import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/chat/chat_message_entity.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
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

  const ChatMessageModel({
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      chatRoomId: chatRoomId,
      senderUserId: senderUserId,
      content: content,
      sentAt: sentAt,
      isRead: isRead,
      isEdited: isEdited,
      messageType: messageType,
      attachmentUrl: attachmentUrl,
      editedAt: editedAt,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      isMine: isMine,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      chatRoomId: entity.chatRoomId,
      senderUserId: entity.senderUserId,
      content: entity.content,
      sentAt: entity.sentAt,
      isRead: entity.isRead,
      isEdited: entity.isEdited,
      messageType: entity.messageType,
      attachmentUrl: entity.attachmentUrl,
      editedAt: entity.editedAt,
      senderName: entity.senderName,
      senderAvatarUrl: entity.senderAvatarUrl,
      isMine: entity.isMine,
    );
  }

  ChatMessageModel copyWith({
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
    return ChatMessageModel(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessageModel &&
        other.id == id &&
        other.chatRoomId == chatRoomId &&
        other.senderUserId == senderUserId &&
        other.content == content &&
        other.sentAt == sentAt &&
        other.isRead == isRead &&
        other.isEdited == isEdited &&
        other.messageType == messageType &&
        other.attachmentUrl == attachmentUrl &&
        other.editedAt == editedAt &&
        other.senderName == senderName &&
        other.senderAvatarUrl == senderAvatarUrl &&
        other.isMine == isMine;
  }

  @override
  int get hashCode {
    return Object.hash(
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
    );
  }

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, chatRoomId: $chatRoomId, senderUserId: $senderUserId, content: $content, sentAt: $sentAt, isRead: $isRead, isEdited: $isEdited, messageType: $messageType, attachmentUrl: $attachmentUrl, editedAt: $editedAt, senderName: $senderName, senderAvatarUrl: $senderAvatarUrl, isMine: $isMine)';
  }
}