import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';

abstract class ReviewRepository {
	Future<Either<Failure, ReviewEntity>> createReview(
		ReviewRequestEntity request,
	);
	Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId);
	Future<Either<Failure, ReviewEntity>> updateReview(
		String reviewId, {
		int? rating,
		String? reviewText,
		List<String>? imageUrls,
	});
	Future<Either<Failure, void>> deleteReview(String reviewId);
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByOrderId(
		String orderId,
	);
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByUserId(
		String userId,
	);
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByLivestreamId(
		String livestreamId,
	);
	Future<Either<Failure, List<ReviewEntity>>> getReviewsByProductId(
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

