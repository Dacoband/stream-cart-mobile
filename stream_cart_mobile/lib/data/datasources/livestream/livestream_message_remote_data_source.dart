import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/livestream/livestream_message_model.dart';

abstract class LiveStreamMessageRemoteDataSource {
	Future<LiveStreamChatMessageModel> joinChat(String liveStreamId);
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
			return LiveStreamChatMessageModel.fromJson(resp.data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to join chat');
		} catch (e) {
			throw Exception('Failed to join chat: $e');
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
