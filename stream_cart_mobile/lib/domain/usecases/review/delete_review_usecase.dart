import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/review/review_repository.dart';

class DeleteReviewParams {
  final String reviewId;

  DeleteReviewParams({required this.reviewId});
}

class DeleteReviewUseCase {
  final ReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteReviewParams params) async {
    return repository.deleteReview(params.reviewId);
  }
}
