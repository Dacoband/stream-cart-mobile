import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../models/chatbot/chat_bot_model.dart';

abstract class ChatBotRemoteDataSource {
  Future<ChatBotHistoryModel> getHistory();
  Future<ChatBotMessageResponseModel> sendMessage(String message);
}

class ChatBotRemoteDataSourceImpl implements ChatBotRemoteDataSource {
  final Dio dio;
  ChatBotRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatBotHistoryModel> getHistory() async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.getChatBotHistoryEndpoint);
      final res = await dio.get(endpoint);
      final data = res.data;
      final payload = (data is Map && data['data'] is Map)
          ? Map<String, dynamic>.from(data['data'] as Map)
          : Map<String, dynamic>.from(data as Map);
      return ChatBotHistoryModel.fromJson(payload);
    } on DioException catch (e) {
      throw Exception('Failed to get chatbot history: ${e.message}');
    }
  }

  @override
  Future<ChatBotMessageResponseModel> sendMessage(String message) async {
    try {
      final endpoint = ApiUrlHelper.getEndpoint(ApiConstants.sendChatBotMessageEndpoint);
      final res = await dio.post(endpoint, data: {
        'message': message,
      });
      final data = res.data;
      final payload = (data is Map && data['data'] is Map)
          ? Map<String, dynamic>.from(data['data'] as Map)
          : Map<String, dynamic>.from(data as Map);
      return ChatBotMessageResponseModel.fromJson(payload);
    } on DioException catch (e) {
      throw Exception('Failed to send chatbot message: ${e.message}');
    }
  }
}
