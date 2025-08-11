import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/livestream/livestream_model.dart';

abstract class LiveStreamRemoteDataSource {
	Future<LiveStreamModel> getLiveStream(String id);
	Future<LiveStreamModel> joinLiveStream(String id);
	Future<List<LiveStreamModel>> getLiveStreamsByShop(String shopId);
}

class LiveStreamRemoteDataSourceImpl implements LiveStreamRemoteDataSource {
	final Dio _dio;

	LiveStreamRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<LiveStreamModel> getLiveStream(String id) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getLiveStreamEndpoint.replaceAll('{id}', id),
			);
			return LiveStreamModel.fromJson(resp.data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get livestream');
		} catch (e) {
			throw Exception('Failed to get livestream: $e');
		}
	}

	@override
	Future<LiveStreamModel> joinLiveStream(String id) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getJoinLiveStreamEndpoint.replaceAll('{id}', id),
			);
			return LiveStreamModel.fromJson(resp.data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to join livestream');
		} catch (e) {
			throw Exception('Failed to join livestream: $e');
		}
	}

	@override
	Future<List<LiveStreamModel>> getLiveStreamsByShop(String shopId) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getLiveStreamByShopIdEndpoint.replaceAll('{shopId}', shopId),
			);
			final data = resp.data as List<dynamic>;
			return data.map((j) => LiveStreamModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get shop livestreams');
		} catch (e) {
			throw Exception('Failed to get shop livestreams: $e');
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
