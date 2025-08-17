import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsByUserParams {
  final String userId;

  GetReviewsByUserParams({required this.userId});
}

class GetReviewsByUserUseCase {
  final ReviewRepository repository;

  GetReviewsByUserUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(GetReviewsByUserParams params) async {
    return repository.getReviewsByUserId(params.userId);
  }
}
