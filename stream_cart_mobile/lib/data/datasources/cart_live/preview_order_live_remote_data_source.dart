import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/cart_live/preview_order_live_model.dart';

abstract class PreviewOrderLiveRemoteDataSource {
	Future<PreviewOrderLiveModel> getPreviewOrderLive(List<String> cartItemIds);
}

class PreviewOrderLiveRemoteDataSourceImpl implements PreviewOrderLiveRemoteDataSource {
	final Dio _dio;
	PreviewOrderLiveRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<PreviewOrderLiveModel> getPreviewOrderLive(List<String> cartItemIds) async {
		try {
			final response = await _dio.get(
				ApiConstants.getPreviewOrderLiveCartEndpoint,
				queryParameters: {
					'CartItemId': cartItemIds,
				},
			);

			return PreviewOrderLiveModel.fromJson(response.data['data'] ?? response.data);
		} on DioException catch (e) {
			throw _handleDioException(e);
		} catch (e) {
			throw Exception('Failed to get live cart preview order: $e');
		}
	}

	Exception _handleDioException(DioException e) {
		switch (e.type) {
			case DioExceptionType.connectionTimeout:
			case DioExceptionType.sendTimeout:
			case DioExceptionType.receiveTimeout:
				return Exception('Connection timeout');
			case DioExceptionType.badResponse:
				final statusCode = e.response?.statusCode;
				final message = e.response?.data?['message'] ?? 'Request failed';
				return Exception('HTTP $statusCode: $message');
			case DioExceptionType.cancel:
				return Exception('Request cancelled');
			case DioExceptionType.connectionError:
				return Exception('No internet connection');
			default:
				return Exception('Network error: ${e.message}');
		}
	}
}
