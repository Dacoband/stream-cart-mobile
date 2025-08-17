import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsByProductParams {
  final String productId;
  final int pageNumber;
  final int pageSize;
  final int? minRating;
  final int? maxRating;
  final bool? verifiedOnly;
  final String? sortBy;
  final bool ascending;

  GetReviewsByProductParams({
    required this.productId,
    this.pageNumber = 1,
    this.pageSize = 10,
    this.minRating,
    this.maxRating,
    this.verifiedOnly,
    this.sortBy,
    this.ascending = false,
  });
}

class GetReviewsByProductUseCase {
  final ReviewRepository repository;

  GetReviewsByProductUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(GetReviewsByProductParams params) async {
    return repository.getReviewsByProductId(
      params.productId,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
      minRating: params.minRating,
      maxRating: params.maxRating,
      verifiedOnly: params.verifiedOnly,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}
