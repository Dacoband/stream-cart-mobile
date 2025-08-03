// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      shopId: json['shopId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      relatedOrderId: json['relatedOrderId'] as String?,
      isActive: json['isActive'] as bool,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      shopName: json['shopName'] as String,
      shopLogoUrl: json['shopLogoUrl'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$ChatRoomModelToJson(ChatRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'shopId': instance.shopId,
      'startedAt': instance.startedAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'relatedOrderId': instance.relatedOrderId,
      'isActive': instance.isActive,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'shopName': instance.shopName,
      'shopLogoUrl': instance.shopLogoUrl,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
    };
