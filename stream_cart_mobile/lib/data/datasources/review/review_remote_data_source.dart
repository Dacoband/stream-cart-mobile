import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/review/review_model.dart';

abstract class ReviewRemoteDataSource {
	Future<ReviewModel> createReview(ReviewRequestModel request);
	Future<ReviewModel> getReviewById(String reviewId);
	Future<ReviewModel> updateReview(
		String reviewId, {
		int? rating,
		String? reviewText,
		List<String>? imageUrls,
	});
	Future<void> deleteReview(String reviewId);

	Future<List<ReviewModel>> getReviewsByOrderId(String orderId);
	Future<List<ReviewModel>> getReviewsByUserId(String userId);
	Future<List<ReviewModel>> getReviewsByLivestreamId(String livestreamId);
	Future<List<ReviewModel>> getReviewsByProductId(
		String productId, {
		int pageNumber = 1,
		int pageSize = 10,
		int? minRating,
		int? maxRating,
		bool? verifiedOnly,
		String? sortBy,
		bool ascending = false,
	});
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
	final Dio _dio;

	ReviewRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

	@override
	Future<ReviewModel> createReview(ReviewRequestModel request) async {
		try {
			final resp = await _dio.post(
				ApiConstants.createReviewEndpoint,
				data: request.toJson(),
			);
			final data = _unwrapObject(resp.data);
			return ReviewModel.fromJson(data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Tạo đánh giá thất bại');
		} catch (e) {
			throw Exception('Tạo đánh giá thất bại: $e');
		}
	}

	@override
	Future<ReviewModel> getReviewById(String reviewId) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getReviewByIdEndpoint.replaceAll('{id}', reviewId),
			);
			final data = _unwrapObject(resp.data);
			return ReviewModel.fromJson(data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Lấy đánh giá thất bại');
		} catch (e) {
			throw Exception('Lấy đánh giá thất bại: $e');
		}
	}

	@override
	Future<ReviewModel> updateReview(
		String reviewId, {
		int? rating,
		String? reviewText,
		List<String>? imageUrls,
	}) async {
		try {
			final body = <String, dynamic>{};
			if (rating != null) body['rating'] = rating;
			if (reviewText != null) body['reviewText'] = reviewText;
			if (imageUrls != null) body['imageUrls'] = imageUrls;

			final resp = await _dio.put(
				ApiConstants.updateReviewEndpoint.replaceAll('{id}', reviewId),
				data: body.isNotEmpty ? body : null,
			);
			final data = _unwrapObject(resp.data);
			return ReviewModel.fromJson(data);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Cập nhật đánh giá thất bại');
		} catch (e) {
			throw Exception('Cập nhật đánh giá thất bại: $e');
		}
	}

	@override
	Future<void> deleteReview(String reviewId) async {
		try {
			await _dio.delete(
				ApiConstants.deleteReviewEndpoint.replaceAll('{id}', reviewId),
			);
		} on DioException catch (e) {
			throw _handleDioException(e, 'Xóa đánh giá thất bại');
		} catch (e) {
			throw Exception('Xóa đánh giá thất bại: $e');
		}
	}

	@override
	Future<List<ReviewModel>> getReviewsByOrderId(String orderId) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getReviewByOrderEndpoint.replaceAll('{orderId}', orderId),
			);
			final list = _unwrapList(resp.data);
			return list.map((j) => ReviewModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Lấy đánh giá theo đơn hàng thất bại');
		} catch (e) {
			throw Exception('Lấy đánh giá theo đơn hàng thất bại: $e');
		}
	}

	@override
	Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getReviewsByUserIdEndpoint.replaceAll('{userId}', userId),
			);
			final list = _unwrapList(resp.data);
			return list.map((j) => ReviewModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Lấy đánh giá theo người dùng thất bại');
		} catch (e) {
			throw Exception('Lấy đánh giá theo người dùng thất bại: $e');
		}
	}

	@override
	Future<List<ReviewModel>> getReviewsByLivestreamId(String livestreamId) async {
		try {
			final resp = await _dio.get(
				ApiConstants.getReviewsByLivestreamIdEndpoint.replaceAll('{livestreamId}', livestreamId),
			);
			final list = _unwrapList(resp.data);
			return list.map((j) => ReviewModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Lấy đánh giá theo livestream thất bại');
		} catch (e) {
			throw Exception('Lấy đánh giá theo livestream thất bại: $e');
		}
	}

	@override
	Future<List<ReviewModel>> getReviewsByProductId(
		String productId, {
		int pageNumber = 1,
		int pageSize = 10,
		int? minRating,
		int? maxRating,
		bool? verifiedOnly,
		String? sortBy,
		bool ascending = false,
	}) async {
		try {
			final query = <String, dynamic>{
				'pageNumber': pageNumber,
				'pageSize': pageSize,
				'ascending': ascending,
			};
			if (minRating != null) query['minRating'] = minRating;
			if (maxRating != null) query['maxRating'] = maxRating;
			if (verifiedOnly != null) query['verifiedOnly'] = verifiedOnly;
			if (sortBy != null) query['sortBy'] = sortBy;

			final resp = await _dio.get(
				ApiConstants.getReviewsByProductIdEndpoint.replaceAll('{productId}', productId),
				queryParameters: query,
			);
			final list = _unwrapList(resp.data);
			return list.map((j) => ReviewModel.fromJson(j)).toList();
		} on DioException catch (e) {
			throw _handleDioException(e, 'Lấy đánh giá theo sản phẩm thất bại');
		} catch (e) {
			throw Exception('Lấy đánh giá theo sản phẩm thất bại: $e');
		}
	}

	// Helpers
	Map<String, dynamic> _unwrapObject(dynamic raw) {
		if (raw is Map<String, dynamic>) {
			if (raw['data'] is Map<String, dynamic>) return raw['data'] as Map<String, dynamic>;
			return raw;
		}
		throw Exception('Định dạng phản hồi không hợp lệ');
	}

	List<dynamic> _unwrapList(dynamic raw) {
		if (raw is List) return raw;
		if (raw is Map<String, dynamic>) {
			if (raw['items'] is List) return raw['items'] as List<dynamic>;
			if (raw['data'] is List) return raw['data'] as List<dynamic>;
			if (raw['data'] is Map && (raw['data'] as Map)['items'] is List) {
				return (raw['data'] as Map)['items'] as List<dynamic>;
			}
		}
		return <dynamic>[];
	}

	Exception _handleDioException(DioException e, String fallback) {
		switch (e.type) {
			case DioExceptionType.connectionTimeout:
			case DioExceptionType.sendTimeout:
			case DioExceptionType.receiveTimeout:
				return Exception('Hết thời gian kết nối');
			case DioExceptionType.badResponse:
				final statusCode = e.response?.statusCode;
				final message = e.response?.data is Map && e.response?.data['message'] != null
						? e.response?.data['message']
						: fallback;
				return Exception('HTTP $statusCode: $message');
			case DioExceptionType.cancel:
				return Exception('Yêu cầu đã bị hủy');
			case DioExceptionType.connectionError:
				return Exception('Không có kết nối internet');
			default:
				return Exception(fallback);
		}
	}
}

