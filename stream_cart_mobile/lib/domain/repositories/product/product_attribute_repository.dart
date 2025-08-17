import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/product_attribute_entity.dart';

abstract class ProductAttributeRepository {
  Future<Either<Failure, List<ProductAttributeEntity>>> getAllProductAttributes();
  Future<Either<Failure, ProductAttributeEntity>> getProductAttributeById(String id);
  Future<Either<Failure, List<ProductAttributeEntity>>> getProductAttributesByProduct(String productId);
  Future<Either<Failure, List<ProductAttributeEntity>>> getProductAttributesWithValues(String attributeId);
}