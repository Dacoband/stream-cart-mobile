import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import 'chat_message_model.dart';

part 'chat_room_model.g.dart';

@JsonSerializable()
class ChatRoomModel {
  final String id;
  final String userId;
  final String shopId;
  final DateTime startedAt;
  final DateTime? lastMessageAt;
  final String? relatedOrderId;
  final bool isActive;
  final String userName;
  final String? userAvatarUrl;
  final String? shopName;
  final String? shopLogoUrl;
  final ChatMessageModel? lastMessage;
  @JsonKey(defaultValue: 0)
  final int unreadCount;

  const ChatRoomModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.startedAt,
    this.lastMessageAt,
    this.relatedOrderId,
    required this.isActive,
    required this.userName,
    this.userAvatarUrl,
    this.shopName,
    this.shopLogoUrl,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);

  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      id: id,
      userId: userId,
      shopId: shopId,
      startedAt: startedAt,
      lastMessageAt: lastMessageAt,
      relatedOrderId: relatedOrderId,
      isActive: isActive,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      shopName: shopName,
      shopLogoUrl: shopLogoUrl,
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
    );
  }

  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      userId: entity.userId,
      shopId: entity.shopId,
      startedAt: entity.startedAt,
      lastMessageAt: entity.lastMessageAt,
      relatedOrderId: entity.relatedOrderId,
      isActive: entity.isActive,
      userName: entity.userName,
      userAvatarUrl: entity.userAvatarUrl,
      shopName: entity.shopName,
      shopLogoUrl: entity.shopLogoUrl,
      lastMessage: entity.lastMessage != null 
          ? ChatMessageModel.fromEntity(entity.lastMessage!) 
          : null,
      unreadCount: entity.unreadCount,
    );
  }

  ChatRoomModel copyWith({
    String? id,
    String? userId,
    String? shopId,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    String? relatedOrderId,
    bool? isActive,
    String? userName,
    String? userAvatarUrl,
    String? shopName,
    String? shopLogoUrl,
    ChatMessageModel? lastMessage,
    int? unreadCount,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      startedAt: startedAt ?? this.startedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      isActive: isActive ?? this.isActive,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      shopName: shopName ?? this.shopName,
      shopLogoUrl: shopLogoUrl ?? this.shopLogoUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoomModel &&
        other.id == id &&
        other.userId == userId &&
        other.shopId == shopId &&
        other.startedAt == startedAt &&
        other.lastMessageAt == lastMessageAt &&
        other.relatedOrderId == relatedOrderId &&
        other.isActive == isActive &&
        other.userName == userName &&
        other.userAvatarUrl == userAvatarUrl &&
        other.shopName == shopName &&
        other.shopLogoUrl == shopLogoUrl &&
        other.lastMessage == lastMessage &&
        other.unreadCount == unreadCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      shopId,
      startedAt,
      lastMessageAt,
      relatedOrderId,
      isActive,
      userName,
      userAvatarUrl,
      shopName,
      shopLogoUrl,
      lastMessage,
      unreadCount,
    );
  }

  @override
  String toString() {
    return 'ChatRoomModel(id: $id, userId: $userId, shopId: $shopId, startedAt: $startedAt, lastMessageAt: $lastMessageAt, relatedOrderId: $relatedOrderId, isActive: $isActive, userName: $userName, userAvatarUrl: $userAvatarUrl, shopName: $shopName, shopLogoUrl: $shopLogoUrl, lastMessage: $lastMessage, unreadCount: $unreadCount)';
  }
}