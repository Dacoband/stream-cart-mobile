import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class UpdateReviewParams {
  final String reviewId;
  final int? rating;
  final String? reviewText;
  final List<String>? imageUrls;

  UpdateReviewParams({
    required this.reviewId,
    this.rating,
    this.reviewText,
    this.imageUrls,
  });
}

class UpdateReviewUseCase {
  final ReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  Future<Either<Failure, ReviewEntity>> call(UpdateReviewParams params) async {
    return repository.updateReview(
      params.reviewId,
      rating: params.rating,
      reviewText: params.reviewText,
      imageUrls: params.imageUrls,
    );
  }
}
