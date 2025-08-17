import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsByOrderParams {
  final String orderId;

  GetReviewsByOrderParams({required this.orderId});
}

class GetReviewsByOrderUseCase {
  final ReviewRepository repository;

  GetReviewsByOrderUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(GetReviewsByOrderParams params) async {
    return repository.getReviewsByOrderId(params.orderId);
  }
}
