import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_variants_entity.dart';

abstract class ProductVariantsRepository {
  Future<Either<Failure, List<ProductVariantEntity>>> getProductVariants();
  Future<Either<Failure, ProductVariantEntity>> getProductVariantById(String id);
  Future<Either<Failure, List<ProductVariantEntity>>> getProductVariantsByProductId(String productId);
  Future<Either<Failure, ProductVariantEntity>> updateProductVariantPrice(String id, double price);
  Future<Either<Failure, ProductVariantEntity>> updateProductVariantStock(String id, int stock);
}