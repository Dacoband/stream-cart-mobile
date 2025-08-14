import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/livestream/livestream_product_model.dart';

abstract class LiveStreamProductRemoteDataSource {
	Future<List<LiveStreamProductModel>> getProductsByLiveStream(String liveStreamId);
	Future<List<LiveStreamProductModel>> getPinnedProductsByLiveStream(String liveStreamId, {int? limit});
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
			final body = resp.data;
			List<dynamic> list;
			if (body is List) {
				list = body;
			} else if (body is Map<String, dynamic>) {
				final d = body['data'];
				if (d is List) {
					list = d;
				} else {
					list = const [];
				}
			} else {
				list = const [];
			}
			return list.map((j) => LiveStreamProductModel.fromJson(Map<String, dynamic>.from(j as Map))).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get livestream products');
		} catch (e) {
			throw Exception('Failed to get livestream products: $e');
		}
	}

	@override
	Future<List<LiveStreamProductModel>> getPinnedProductsByLiveStream(String liveStreamId, {int? limit}) async {
		try {
			final path = ApiConstants.getProductPinnedByLiveStreamIdEndpoint.replaceAll('{livestreamId}', liveStreamId);
			final resp = await _dio.get(
				path,
				queryParameters: {
					if (limit != null) 'limit': limit,
				},
			);
			final body = resp.data;
			List<dynamic> list;
			if (body is List) {
				list = body;
			} else if (body is Map<String, dynamic>) {
				final d = body['data'];
				if (d is List) {
					list = d;
				} else {
					list = const [];
				}
			} else {
				list = const [];
			}
			return list.map((j) => LiveStreamProductModel.fromJson(Map<String, dynamic>.from(j as Map))).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Failed to get pinned livestream products');
		} catch (e) {
			throw Exception('Failed to get pinned livestream products: $e');
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
