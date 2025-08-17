import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsByLivestreamParams {
  final String livestreamId;

  GetReviewsByLivestreamParams({required this.livestreamId});
}

class GetReviewsByLivestreamUseCase {
  final ReviewRepository repository;

  GetReviewsByLivestreamUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(GetReviewsByLivestreamParams params) async {
    return repository.getReviewsByLivestreamId(params.livestreamId);
  }
}
