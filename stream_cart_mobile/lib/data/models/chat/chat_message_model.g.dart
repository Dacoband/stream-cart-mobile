// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      chatRoomId: json['chatRoomId'] as String,
      senderUserId: json['senderUserId'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool,
      isEdited: json['isEdited'] as bool,
      messageType: json['messageType'] as String,
      attachmentUrl: json['attachmentUrl'] as String?,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      isMine: json['isMine'] as bool,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'senderUserId': instance.senderUserId,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
      'messageType': instance.messageType,
      'attachmentUrl': instance.attachmentUrl,
      'editedAt': instance.editedAt?.toIso8601String(),
      'senderName': instance.senderName,
      'senderAvatarUrl': instance.senderAvatarUrl,
      'isMine': instance.isMine,
    };
