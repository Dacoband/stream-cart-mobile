import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_variants_entity.dart';
import '../../repositories/product/product_variants_repository.dart';

class GetAvailableVariants {
  final ProductVariantsRepository repository;

  GetAvailableVariants(this.repository);

  Future<Either<Failure, List<ProductVariantEntity>>> call(String productId) async {
    final result = await repository.getProductVariantsByProductId(productId);
    
    return result.fold(
      (failure) => Left(failure),
      (variants) {
        // Lọc chỉ những variant còn hàng
        final availableVariants = variants.where((variant) => variant.stock > 0).toList();
        return Right(availableVariants);
      },
    );
  }
}