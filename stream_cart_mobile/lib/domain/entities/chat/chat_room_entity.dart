import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat/chat_message_entity.dart';

class ChatRoomEntity extends Equatable {
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
  final ChatMessage? lastMessage;
  final int unreadCount;

  const ChatRoomEntity({
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
    required this.unreadCount,
  });

  bool get hasUnreadMessages => unreadCount > 0;

  ChatRoomEntity copyWith({
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
    ChatMessage? lastMessage,
    int? unreadCount,
  }) {
    return ChatRoomEntity(
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
      ];
}

// Thêm class để handle pagination response
class ChatRoomsPaginatedResponse extends Equatable {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final List<ChatRoomEntity> items;

  const ChatRoomsPaginatedResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.items,
  });

  ChatRoomsPaginatedResponse copyWith({
    int? currentPage,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasPrevious,
    bool? hasNext,
    List<ChatRoomEntity>? items,
  }) {
    return ChatRoomsPaginatedResponse(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      hasNext: hasNext ?? this.hasNext,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        pageSize,
        totalCount,
        totalPages,
        hasPrevious,
        hasNext,
        items,
      ];
}