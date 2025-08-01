import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_variants_entity.dart';
import '../../repositories/product/product_variants_repository.dart';

class GetProductVariantsByProductId {
  final ProductVariantsRepository repository;

  GetProductVariantsByProductId(this.repository);

  Future<Either<Failure, List<ProductVariantEntity>>> call(String productId) async {
    return await repository.getProductVariantsByProductId(productId);
  }
}