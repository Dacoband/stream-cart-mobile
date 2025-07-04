import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';
import '../../core/error/failures.dart';

class SearchProductsUseCase {
  final HomeRepository repository;

  SearchProductsUseCase(this.repository);

  Future<({List<ProductEntity> products, String? error})> call({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await repository.searchProducts(
        query: query,
        page: page,
        limit: limit,
      );
      
      return result.fold(
        (failure) => (products: <ProductEntity>[], error: failure.message),
        (products) => (products: products, error: null),
      );
    } catch (e) {
      return (products: <ProductEntity>[], error: e.toString());
    }
  }
}
