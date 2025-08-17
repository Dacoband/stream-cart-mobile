import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewByIdParams {
  final String reviewId;

  GetReviewByIdParams({required this.reviewId});
}

class GetReviewByIdUseCase {
  final ReviewRepository repository;

  GetReviewByIdUseCase(this.repository);

  Future<Either<Failure, ReviewEntity>> call(GetReviewByIdParams params) async {
    return repository.getReviewById(params.reviewId);
  }
}
