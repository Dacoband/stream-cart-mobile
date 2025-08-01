import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_variants_entity.dart';
import '../../repositories/product/product_variants_repository.dart';

class GetProductVariantById {
  final ProductVariantsRepository repository;

  GetProductVariantById(this.repository);

  Future<Either<Failure, ProductVariantEntity>> call(String variantId) async {
    return await repository.getProductVariantById(variantId);
  }
}