import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class CreateReviewParams {
  final ReviewRequestEntity request;

  CreateReviewParams({required this.request});
}

class CreateReviewUseCase {
  final ReviewRepository repository;

  CreateReviewUseCase(this.repository);

  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) async {
    return repository.createReview(params.request);
  }
}
