import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class GetProductPrimaryImagesUseCase {
  final HomeRepository repository;

  GetProductPrimaryImagesUseCase(this.repository);

  Future<Either<Failure, Map<String, String>>> call(List<String> productIds) async {   
    final result = await repository.getProductPrimaryImages(productIds);   
    return result.fold(
      (failure) {
        return Left(failure);
      },
      (primaryImages) {
        return Right(primaryImages);
      },
    );
  }
}
