import '../../../domain/entities/livestream/livestream_message_entity.dart';

class LiveStreamChatMessageModel {
  final String id;
  final String livestreamId;
  final String senderId;
  final String senderName;
  final String senderType;
  final String message;
  final int messageType;
  final String? replyToMessageId;
  final bool isModerated;
  final String sentAt;
  final String createdAt;
  final String? senderAvatarUrl;
  final String? replyToMessage;
  final String? replyToSenderName;

  const LiveStreamChatMessageModel({
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

  factory LiveStreamChatMessageModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamChatMessageModel(
      id: json['id'] ?? '',
      livestreamId: json['livestreamId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderType: json['senderType'] ?? '',
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 0,
      replyToMessageId: json['replyToMessageId'],
      isModerated: json['isModerated'] ?? false,
      sentAt: json['sentAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      senderAvatarUrl: json['senderAvatarUrl'],
      replyToMessage: json['replyToMessage'],
      replyToSenderName: json['replyToSenderName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'livestreamId': livestreamId,
        'senderId': senderId,
        'senderName': senderName,
        'senderType': senderType,
        'message': message,
        'messageType': messageType,
        'replyToMessageId': replyToMessageId,
        'isModerated': isModerated,
        'sentAt': sentAt,
        'createdAt': createdAt,
        'senderAvatarUrl': senderAvatarUrl,
        'replyToMessage': replyToMessage,
        'replyToSenderName': replyToSenderName,
      };

  LiveStreamChatMessageEntity toEntity() => LiveStreamChatMessageEntity(
        id: id,
        livestreamId: livestreamId,
        senderId: senderId,
        senderName: senderName,
        senderType: senderType,
        message: message,
        messageType: messageType,
        replyToMessageId: replyToMessageId,
        isModerated: isModerated,
        sentAt: DateTime.tryParse(sentAt) ?? DateTime.now(),
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        senderAvatarUrl: senderAvatarUrl,
        replyToMessage: replyToMessage,
        replyToSenderName: replyToSenderName,
      );
}
