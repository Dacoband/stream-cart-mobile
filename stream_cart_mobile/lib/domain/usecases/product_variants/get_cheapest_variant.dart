import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_variants_entity.dart';
import '../../repositories/product/product_variants_repository.dart';

class GetCheapestVariant {
  final ProductVariantsRepository repository;

  GetCheapestVariant(this.repository);

  Future<Either<Failure, ProductVariantEntity?>> call(String productId) async {
    final result = await repository.getProductVariantsByProductId(productId);
    
    return result.fold(
      (failure) => Left(failure),
      (variants) {
        if (variants.isEmpty) {
          return const Right(null);
        }
        
        // Tìm variant có giá thấp nhất (ưu tiên flash sale price nếu có)
        ProductVariantEntity cheapest = variants.first;
        for (final variant in variants) {
          final currentPrice = variant.flashSalePrice > 0 ? variant.flashSalePrice : variant.price;
          final cheapestPrice = cheapest.flashSalePrice > 0 ? cheapest.flashSalePrice : cheapest.price;
          
          if (currentPrice < cheapestPrice && variant.stock > 0) {
            cheapest = variant;
          }
        }
        
        return Right(cheapest);
      },
    );
  }
}