import 'package:dartz/dartz.dart';
import '../../entities/search/search_response_entity.dart';
import '../../repositories/search_repository.dart';
import '../../../core/error/failures.dart';

class SearchProductsAdvancedUseCase {
  final SearchRepository repository;

  SearchProductsAdvancedUseCase(this.repository);

  Future<Either<Failure, SearchResponseEntity>> call({
    required String searchTerm,
    int? pageNumber,
    int? pageSize,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? sortBy,
    bool? inStockOnly,
    int? minRating,
    bool? onSaleOnly,
  }) async {
    // Validate search term
    if (searchTerm.trim().isEmpty) {
      return Left(ValidationFailure('Từ khóa tìm kiếm không được để trống'));
    }

    // Validate price range
    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      return Left(ValidationFailure('Giá tối thiểu không được lớn hơn giá tối đa'));
    }

    // Validate rating
    if (minRating != null && (minRating < 1 || minRating > 5)) {
      return Left(ValidationFailure('Đánh giá phải từ 1 đến 5 sao'));
    }

    return await repository.searchProducts(
      searchTerm: searchTerm.trim(),
      pageNumber: pageNumber ?? 1,
      pageSize: pageSize ?? 20,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      shopId: shopId,
      sortBy: sortBy ?? 'relevance',
      inStockOnly: inStockOnly ?? false,
      minRating: minRating,
      onSaleOnly: onSaleOnly ?? false,
    );
  }
}
