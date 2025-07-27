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
    this.liveKitRoomName,
    required this.customerToken,
    required this.isLiveKitActive,
  });

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
        liveKitRoomName,
        isLiveKitActive,
        customerToken,
      ];
}

