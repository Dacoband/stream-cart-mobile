import 'package:dartz/dartz.dart';
import '../entities/search/search_response_entity.dart';
import '../../core/error/failures.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResponseEntity>> searchProducts({
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
  });
}
