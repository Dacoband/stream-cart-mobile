import 'package:dartz/dartz.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';
import '../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 20});
  Future<Either<Failure, List<ProductEntity>>> searchProducts({required String query, int page = 1, int limit = 20});
}
