import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/review/review_entity.dart';
import '../../../domain/repositories/review/review_repository.dart';
import '../../datasources/review/review_remote_data_source.dart';
import '../../models/review/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
	final ReviewRemoteDataSource remote;

	ReviewRepositoryImpl({required this.remote});

	@override
	Future<Either<Failure, ReviewEntity>> createReview(
		ReviewRequestEntity request,
	) async {
		try {
			final model = ReviewRequestModel.fromEntity(request);
			final result = await remote.createReview(model);
			return Right(result.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể tạo đánh giá',
					badRequest: 'Dữ liệu đánh giá không hợp lệ'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId) async {
		try {
			final result = await remote.getReviewById(reviewId);
			return Right(result.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể lấy đánh giá',
					notFound: 'Không tìm thấy đánh giá'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, ReviewEntity>> updateReview(
		String reviewId, {
		int? rating,
		String? reviewText,
		List<String>? imageUrls,
	}) async {
		try {
			final result = await remote.updateReview(
				reviewId,
				rating: rating,
				reviewText: reviewText,
				imageUrls: imageUrls,
			);
			return Right(result.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể cập nhật đánh giá',
					notFound: 'Không tìm thấy đánh giá'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, void>> deleteReview(String reviewId) async {
		try {
			await remote.deleteReview(reviewId);
			return const Right(null);
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể xóa đánh giá',
					notFound: 'Không tìm thấy đánh giá'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByOrderId(String orderId) async {
		try {
			final list = await remote.getReviewsByOrderId(orderId);
			return Right(list.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể lấy đánh giá theo đơn hàng',
					notFound: 'Không có đánh giá cho đơn hàng này'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByUserId(String userId) async {
		try {
			final list = await remote.getReviewsByUserId(userId);
			return Right(list.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể lấy đánh giá của người dùng',
					notFound: 'Người dùng chưa có đánh giá'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByLivestreamId(String livestreamId) async {
		try {
			final list = await remote.getReviewsByLivestreamId(livestreamId);
			return Right(list.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể lấy đánh giá livestream',
					notFound: 'Không có đánh giá cho livestream này'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	@override
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByProductId(
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
			final list = await remote.getReviewsByProductId(
				productId,
				pageNumber: pageNumber,
				pageSize: pageSize,
				minRating: minRating,
				maxRating: maxRating,
				verifiedOnly: verifiedOnly,
				sortBy: sortBy,
				ascending: ascending,
			);
			return Right(list.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					defaultMsg: 'Không thể lấy đánh giá sản phẩm',
					notFound: 'Chưa có đánh giá cho sản phẩm này'));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: $e'));
		}
	}

	Failure _mapDioToFailure(
		DioException e, {
		String? defaultMsg,
		String? badRequest,
		String? unauthorized,
		String? forbidden,
		String? notFound,
	}) {
		final status = e.response?.statusCode;
		final dataMessage = e.response?.data is Map<String, dynamic>
				? e.response?.data['message'] as String?
				: null;
		switch (status) {
			case 400:
				return ServerFailure(badRequest ?? dataMessage ?? (defaultMsg ?? 'Yêu cầu không hợp lệ'));
			case 401:
				return UnauthorizedFailure(unauthorized ?? 'Vui lòng đăng nhập');
			case 403:
				return ServerFailure(forbidden ?? 'Không có quyền truy cập');
			case 404:
				return ServerFailure(notFound ?? 'Không tìm thấy dữ liệu');
			case 409:
				return ConflictFailure(dataMessage ?? (defaultMsg ?? 'Xung đột dữ liệu'));
			case 422:
				return ValidationFailure(dataMessage ?? (defaultMsg ?? 'Không thể xử lý yêu cầu'));
			case 429:
				return TooManyRequestsFailure('Thao tác quá nhanh, thử lại sau');
			default:
				if (e.type == DioExceptionType.connectionTimeout ||
						e.type == DioExceptionType.receiveTimeout ||
						e.type == DioExceptionType.sendTimeout ||
						e.type == DioExceptionType.connectionError) {
					return NetworkFailure('Lỗi kết nối: ${e.message}');
				}
				return ServerFailure(defaultMsg ?? 'Lỗi máy chủ: ${e.message}');
		}
	}
}

