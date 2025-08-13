import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/livestream/livestream_message_model.dart';

abstract class LiveStreamMessageRemoteDataSource {
	Future<LiveStreamChatMessageModel> joinChat(String liveStreamId);
	Future<LiveStreamChatMessageModel> sendMessage({
		required String liveStreamId,
		required String message,
		int messageType = 0,
		String? replyToMessageId,
	});
	Future<List<LiveStreamChatMessageModel>> getMessages(String liveStreamId);
}

class LiveStreamMessageRemoteDataSourceImpl implements LiveStreamMessageRemoteDataSource {
	final Dio _dio;

	LiveStreamMessageRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<LiveStreamChatMessageModel> joinChat(String liveStreamId) async {
		try {
			final resp = await _dio.post(
				ApiConstants.joinChatLiveStreamEndpoint.replaceAll('{livestreamId}', liveStreamId),
			);
			final body = resp.data;
			if (body is Map<String, dynamic>) {
				final data = body['data'];
				if (data is Map<String, dynamic>) {
					return LiveStreamChatMessageModel.fromJson(data);
				}
				return LiveStreamChatMessageModel.fromJson(body);
			}
			throw Exception('Unexpected response format');
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to join chat');
		} catch (e) {
			throw Exception('Failed to join chat: $e');
		}
	}

	@override
	Future<LiveStreamChatMessageModel> sendMessage({
		required String liveStreamId,
		required String message,
		int messageType = 0,
		String? replyToMessageId,
	}) async {
		try {
			final url = ApiConstants.sendMessageChatLiveStreamEndpoint.replaceAll('{livestreamId}', liveStreamId);
			final resp = await _dio.post(
				url,
				data: {
					'message': message,
					'messageType': messageType,
					if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
				},
			);
			final body = resp.data;
			if (body is Map<String, dynamic>) {
				final data = body['data'];
				if (data is Map<String, dynamic>) {
					return LiveStreamChatMessageModel.fromJson(data);
				}
				return LiveStreamChatMessageModel.fromJson(body);
			}
			throw Exception('Unexpected response format');
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to send message');
		} catch (e) {
			throw Exception('Failed to send message: $e');
		}
	}

	@override
	Future<List<LiveStreamChatMessageModel>> getMessages(String liveStreamId) async {
		try {
			final url = ApiConstants.getMessageChatLiveStreamEndpoint.replaceAll('{livestreamId}', liveStreamId);
			final resp = await _dio.get(url);
			final body = resp.data;
			List<dynamic> list;
			if (body is List) {
				list = body;
			} else if (body is Map<String, dynamic>) {
				final data = body['data'];
				if (data is List) {
					list = data;
				} else {
					list = const [];
				}
			} else {
				list = const [];
			}
			return list
				.map((e) => LiveStreamChatMessageModel.fromJson(Map<String, dynamic>.from(e as Map)))
				.toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get messages');
		} catch (e) {
			throw Exception('Failed to get messages: $e');
		}
	}

	Exception _handleDioException(DioException e, String defaultMsg) {
		switch (e.type) {
			case DioExceptionType.connectionTimeout:
			case DioExceptionType.sendTimeout:
			case DioExceptionType.receiveTimeout:
				return Exception('Connection timeout');
			case DioExceptionType.badResponse:
				final statusCode = e.response?.statusCode;
				final message = e.response?.data?['message'] ?? defaultMsg;
				return Exception('HTTP $statusCode: $message');
			case DioExceptionType.cancel:
				return Exception('Request cancelled');
			case DioExceptionType.connectionError:
				return Exception('No internet connection');
			default:
				return Exception(defaultMsg);
		}
	}
}
