import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/entities/search_response_entity.dart';
import '../../core/error/failures.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
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
  }) async {
    try {
      print('🔍 Repository: Calling searchProducts with term: "$searchTerm"');
      final searchResponse = await remoteDataSource.searchProducts(
        searchTerm: searchTerm,
        pageNumber: pageNumber,
        pageSize: pageSize,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        shopId: shopId,
        sortBy: sortBy,
        inStockOnly: inStockOnly,
        minRating: minRating,
        onSaleOnly: onSaleOnly,
      );

      if (searchResponse.success) {
        final entity = searchResponse.toEntity();
        print('✅ Repository: Search successful - ${entity.data.totalResults} results found');
        return Right(entity);
      } else {
        print('❌ Repository: Search failed: ${searchResponse.message}');
        return Left(ServerFailure(searchResponse.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in searchProducts: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy sản phẩm nào'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in searchProducts: $e');
      return Left(ServerFailure('Có lỗi xảy ra khi tìm kiếm: ${e.toString()}'));
    }
  }
}
