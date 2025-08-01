import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';

class ChatEntity extends Equatable {
  final String id;
  final String userId;
  final String shopId;
  final DateTime startedAt;
  final DateTime lastMessageAt;
  final String? relatedOrderId;
  final bool isActive;
  final String userName;
  final String? userAvatarUrl;
  final String shopName;
  final String? shopLogoUrl;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool hasUnreadMessages;
  final String? liveKitRoomName;
  final String customerToken;
  final bool isLiveKitActive;

  ChatEntity({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.startedAt,
    required this.lastMessageAt,
    this.relatedOrderId,
    required this.isActive,
    required this.userName,
    this.userAvatarUrl,
    required this.shopName,
    this.shopLogoUrl,
    this.lastMessage,
    required this.unreadCount,
    this.hasUnreadMessages = false,
    this.liveKitRoomName,
    required this.customerToken,
    required this.isLiveKitActive,
  });

  ChatEntity copyWith({
    String? id,
    String? userId,
    String? shopId,
    DateTime? startedAt,
    DateTime? lastMessageAt,
    String? relatedOrderId,
    bool? isActive,
    String? userName,
    String? userAvatarUrl,
    String? shopLogoUrl,
    String? shopName,
    String? shopAvatarUrl,
    ChatMessage? lastMessage,
    int? unreadCount,
    bool? hasUnreadMessages,
    String? liveKitRoomName,
    String? customerToken,
    bool? isLiveKitActive,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      startedAt: startedAt ?? this.startedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      isActive: isActive ?? this.isActive,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      shopLogoUrl: shopLogoUrl ?? this.shopLogoUrl,
      shopName: shopName ?? this.shopName,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      liveKitRoomName: liveKitRoomName ?? this.liveKitRoomName,
      customerToken: customerToken ?? this.customerToken,
      isLiveKitActive: isLiveKitActive ?? this.isLiveKitActive,
    );
  }

  @override
  List<Object?> get props => [
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
        hasUnreadMessages,
        liveKitRoomName,
        isLiveKitActive,
        customerToken,
      ];
}

