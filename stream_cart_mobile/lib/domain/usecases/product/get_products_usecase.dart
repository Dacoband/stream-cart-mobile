import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({int page = 1, int limit = 20}) async {
    return await repository.getProducts(page: page, limit: limit);
  }
}

class SearchProductsUseCase {
  final HomeRepository repository;

  SearchProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({required String query, int page = 1, int limit = 20}) async {
    return await repository.searchProducts(query: query, page: page, limit: limit);
  }
}
