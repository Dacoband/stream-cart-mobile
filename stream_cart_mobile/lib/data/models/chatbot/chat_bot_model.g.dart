// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatBotHistoryItemModel _$ChatBotHistoryItemModelFromJson(
        Map<String, dynamic> json) =>
    ChatBotHistoryItemModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      userMessage: json['user_message'] as String,
      aiResponse: json['ai_response'] as String,
    );

Map<String, dynamic> _$ChatBotHistoryItemModelToJson(
        ChatBotHistoryItemModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'user_message': instance.userMessage,
      'ai_response': instance.aiResponse,
    };

ChatBotHistoryModel _$ChatBotHistoryModelFromJson(Map<String, dynamic> json) =>
    ChatBotHistoryModel(
      userId: json['user_id'] as String,
      history: (json['history'] as List<dynamic>)
          .map((e) =>
              ChatBotHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatBotHistoryModelToJson(
        ChatBotHistoryModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'history': instance.history,
    };

ChatBotMessageResponseModel _$ChatBotMessageResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChatBotMessageResponseModel(
      response: json['response'] as String,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChatBotMessageResponseModelToJson(
        ChatBotMessageResponseModel instance) =>
    <String, dynamic>{
      'response': instance.response,
      'status': instance.status,
      'metadata': instance.metadata,
    };
