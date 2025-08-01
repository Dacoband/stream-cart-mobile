import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class GetProductsByCategoryUseCase {
  final HomeRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) async {
    return await repository.getProductsByCategory(categoryId);
  }
}
