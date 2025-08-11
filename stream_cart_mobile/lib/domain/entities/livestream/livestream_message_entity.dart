import 'package:equatable/equatable.dart';

class LiveStreamChatMessageEntity extends Equatable {
  final String id;
  final String livestreamId;
  final String senderId;
  final String senderName;
  final String senderType; 
  final String message;
  final int messageType;
  final String? replyToMessageId;
  final bool isModerated;
  final DateTime sentAt;
  final DateTime createdAt;
  final String? senderAvatarUrl;
  final String? replyToMessage;
  final String? replyToSenderName;

  const LiveStreamChatMessageEntity({
    required this.id,
    required this.livestreamId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.messageType,
    this.replyToMessageId,
    required this.isModerated,
    required this.sentAt,
    required this.createdAt,
    this.senderAvatarUrl,
    this.replyToMessage,
    this.replyToSenderName,
  });

  LiveStreamChatMessageEntity copyWith({
    String? id,
    String? livestreamId,
    String? senderId,
    String? senderName,
    String? senderType,
    String? message,
    int? messageType,
    String? replyToMessageId,
    bool? isModerated,
    DateTime? sentAt,
    DateTime? createdAt,
    String? senderAvatarUrl,
    String? replyToMessage,
    String? replyToSenderName,
  }) => LiveStreamChatMessageEntity(
        id: id ?? this.id,
        livestreamId: livestreamId ?? this.livestreamId,
        senderId: senderId ?? this.senderId,
        senderName: senderName ?? this.senderName,
        senderType: senderType ?? this.senderType,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        replyToMessageId: replyToMessageId ?? this.replyToMessageId,
        isModerated: isModerated ?? this.isModerated,
        sentAt: sentAt ?? this.sentAt,
        createdAt: createdAt ?? this.createdAt,
        senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
        replyToMessage: replyToMessage ?? this.replyToMessage,
        replyToSenderName: replyToSenderName ?? this.replyToSenderName,
      );

  @override
  List<Object?> get props => [
        id,
        livestreamId,
        senderId,
        senderName,
        senderType,
        message,
        messageType,
        replyToMessageId,
        isModerated,
        sentAt,
        createdAt,
        senderAvatarUrl,
        replyToMessage,
        replyToSenderName,
      ];
}
