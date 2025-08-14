import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/chatbot/chat_bot_entity.dart';

part 'chat_bot_model.g.dart';

@JsonSerializable()
class ChatBotHistoryItemModel extends Equatable {
  final DateTime timestamp;
  @JsonKey(name: 'user_message')
  final String userMessage;
  @JsonKey(name: 'ai_response')
  final String aiResponse;

  const ChatBotHistoryItemModel({
    required this.timestamp,
    required this.userMessage,
    required this.aiResponse,
  });

  factory ChatBotHistoryItemModel.fromJson(Map<String, dynamic> json) => _$ChatBotHistoryItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatBotHistoryItemModelToJson(this);

  ChatBotHistoryItem toEntity() => ChatBotHistoryItem(
        timestamp: timestamp,
        userMessage: userMessage,
        aiResponse: aiResponse,
      );

  @override
  List<Object?> get props => [timestamp, userMessage, aiResponse];
}

@JsonSerializable()
class ChatBotHistoryModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  final List<ChatBotHistoryItemModel> history;

  const ChatBotHistoryModel({
    required this.userId,
    required this.history,
  });

  factory ChatBotHistoryModel.fromJson(Map<String, dynamic> json) => _$ChatBotHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatBotHistoryModelToJson(this);

  ChatBotHistoryEntity toEntity() => ChatBotHistoryEntity(
        userId: userId,
        history: history.map((e) => e.toEntity()).toList(),
      );

  @override
  List<Object?> get props => [userId, history];
}

@JsonSerializable()
class ChatBotMessageResponseModel extends Equatable {
  final String response;
  final String status;
  final Map<String, dynamic>? metadata;

  const ChatBotMessageResponseModel({
    required this.response,
    required this.status,
    this.metadata,
  });

  factory ChatBotMessageResponseModel.fromJson(Map<String, dynamic> json) => _$ChatBotMessageResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatBotMessageResponseModelToJson(this);

  ChatBotMessageResponseEntity toEntity() => ChatBotMessageResponseEntity(
        response: response,
        status: status,
        metadata: metadata,
      );

  @override
  List<Object?> get props => [response, status, metadata];
}
