import 'package:dartz/dartz.dart';
import '../../entities/products/product_image_entity.dart';
import '../../repositories/home_repository.dart';
import '../../../core/error/failures.dart';

class GetProductImagesUseCase {
  final HomeRepository repository;

  GetProductImagesUseCase(this.repository);

  Future<Either<Failure, List<ProductImageEntity>>> call(String productId) async {
    print('[GetProductImagesUseCase] Fetching images for product: $productId');
    
    final result = await repository.getProductImages(productId);
    
    return result.fold(
      (failure) {
        print('[GetProductImagesUseCase] Error: ${failure.message}');
        return Left(failure);
      },
      (images) {
        print('[GetProductImagesUseCase] Successfully fetched ${images.length} images');
        return Right(images);
      },
    );
  }
}
