import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/livestream/livestream_product_model.dart';

abstract class LiveStreamProductRemoteDataSource {
	Future<List<LiveStreamProductModel>> getProductsByLiveStream(String liveStreamId);
}

class LiveStreamProductRemoteDataSourceImpl implements LiveStreamProductRemoteDataSource {
	final Dio _dio;

	LiveStreamProductRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<List<LiveStreamProductModel>> getProductsByLiveStream(String liveStreamId) async {
		try {
					final resp = await _dio.get(
						ApiConstants.getProductByLiveStreamIdEndpoint.replaceAll('{livestreamId}', liveStreamId),
					);
			final data = resp.data as List<dynamic>;
			return data.map((j) => LiveStreamProductModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get livestream products');
		} catch (e) {
			throw Exception('Failed to get livestream products: $e');
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
