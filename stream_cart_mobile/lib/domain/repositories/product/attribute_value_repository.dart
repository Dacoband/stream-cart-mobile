import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/products/attribute_value_entity.dart';

abstract class AttributeValueRepository {
  Future<Either<Failure, List<AttributeValueEntity>>> getAllAttributeValues();
  Future<Either<Failure, AttributeValueEntity>> getAttributeValueById(String id);
  Future<Either<Failure, List<AttributeValueEntity>>> getAttributeValuesByAttribute(String attributeId);
}