import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class GetProductPrimaryImagesUseCase {
  final HomeRepository repository;

  GetProductPrimaryImagesUseCase(this.repository);

  Future<Either<Failure, Map<String, String>>> call(List<String> productIds) async {
    print('[GetProductPrimaryImagesUseCase] Fetching primary images for ${productIds.length} products');
    
    final result = await repository.getProductPrimaryImages(productIds);
    
    return result.fold(
      (failure) {
        print('[GetProductPrimaryImagesUseCase] Error: ${failure.message}');
        return Left(failure);
      },
      (primaryImages) {
        print('[GetProductPrimaryImagesUseCase] Successfully fetched ${primaryImages.length} primary images');
        return Right(primaryImages);
      },
    );
  }
}
