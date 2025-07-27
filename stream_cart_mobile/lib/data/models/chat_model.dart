import 'package:equatable/equatable.dart';
import 'package:stream_cart_mobile/domain/entities/chat_message_entity.dart';

import '../../domain/entities/chat_entity.dart';

class ChatResponseModel {
  final bool? success;
  final String? message;
  final ChatModel? data;
  final List<String>? errors;

  ChatResponseModel({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ChatModel.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

class ChatModel extends Equatable {
  final String? id;
  final String? userId;
  final String? shopId;
  final DateTime? startedAt;
  final DateTime? lastMessageAt;
  final String? relatedOrderId;
  final bool? isActive;
  final String? userName;
  final String? userAvatarUrl;
  final String? shopName;
  final String? shopLogoUrl;
  final LastMessageModel? lastMessage;
  final int? unreadCount;
  final String? liveKitRoomName;
  final String? customerToken;
  final bool? isLiveKitActive;

  ChatModel({
    this.id,
    this.userId,
    this.shopId,
    this.startedAt,
    this.lastMessageAt,
    this.relatedOrderId,
    this.isActive,
    this.userName,
    this.userAvatarUrl,
    this.shopName,
    this.shopLogoUrl,
    this.lastMessage,
    this.unreadCount,
    this.liveKitRoomName,
    this.isLiveKitActive,
    this.customerToken,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt']) : null,
      relatedOrderId: json['relatedOrderId'],
      isActive: json['isActive'],
      userName: json['userName'],
      userAvatarUrl: json['userAvatarUrl'],
      shopName: json['shopName'],
      shopLogoUrl: json['shopLogoUrl'],
      lastMessage: json['lastMessage'] != null ? LastMessageModel.fromJson(json['lastMessage']) : null,
      unreadCount: json['unreadCount'],
      liveKitRoomName: json['liveKitRoomName'],
      isLiveKitActive: json['isLiveKitActive'],
      customerToken: json['customerToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'startedAt': startedAt?.toIso8601String(),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'relatedOrderId': relatedOrderId,
      'isActive': isActive,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'shopName': shopName,
      'shopLogoUrl': shopLogoUrl,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'liveKitRoomName': liveKitRoomName,
      'isLiveKitActive': isLiveKitActive,
      'customerToken': customerToken,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id ?? '',
      userId: userId ?? '',
      shopId: shopId ?? '',
      startedAt: startedAt ?? DateTime.now(),
      lastMessageAt: lastMessageAt ?? DateTime.now(),
      relatedOrderId: relatedOrderId,
      isActive: isActive ?? false,
      userName: userName ?? '',
      userAvatarUrl: userAvatarUrl,
      shopName: shopName ?? '',
      shopLogoUrl: shopLogoUrl,
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount ?? 0,
      liveKitRoomName: liveKitRoomName,
      isLiveKitActive: isLiveKitActive ?? false,
      customerToken: customerToken ?? '',
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
        liveKitRoomName,
        isLiveKitActive,
        customerToken,
      ];
}

class LastMessageModel extends Equatable {
  final String? id;
  final String? chatRoomId;
  final String? senderUserId;
  final String? content;
  final DateTime? sentAt;
  final bool? isRead;
  final bool? isEdited;
  final String? messageType;
  final String? attachmentUrl;
  final DateTime? editedAt;
  final String? senderName;
  final String? senderAvatarUrl;
  final bool? isMine;

  LastMessageModel({
    this.id,
    this.chatRoomId,
    this.senderUserId,
    this.content,
    this.sentAt,
    this.isRead,
    this.isEdited,
    this.messageType,
    this.attachmentUrl,
    this.editedAt,
    this.senderName,
    this.senderAvatarUrl,
    this.isMine,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['id'],
      chatRoomId: json['chatRoomId'],
      senderUserId: json['senderUserId'],
      content: json['content'],
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      isRead: json['isRead'],
      isEdited: json['isEdited'],
      messageType: json['messageType'],
      attachmentUrl: json['attachmentUrl'],
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      senderName: json['senderName'],
      senderAvatarUrl: json['senderAvatarUrl'],
      isMine: json['isMine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderUserId': senderUserId,
      'content': content,
      'sentAt': sentAt?.toIso8601String(),
      'isRead': isRead,
      'isEdited': isEdited,
      'messageType': messageType,
      'attachmentUrl': attachmentUrl,
      'editedAt': editedAt?.toIso8601String(),
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'isMine': isMine,
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id ?? '',
      chatRoomId: chatRoomId ?? '',
      senderUserId: senderUserId ?? '',
      content: content ?? '',
      sentAt: sentAt ?? DateTime.now(),
      isRead: isRead ?? false,
      isEdited: isEdited ?? false,
      messageType: messageType ?? '',
      attachmentUrl: attachmentUrl,
      editedAt: editedAt,
      senderName: senderName ?? '',
      senderAvatarUrl: senderAvatarUrl,
      isMine: isMine ?? false,
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
