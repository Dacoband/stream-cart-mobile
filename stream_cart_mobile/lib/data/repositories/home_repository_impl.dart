import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../core/error/failures.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      print('🌐 Repository: Calling getCategories API...');
      final response = await remoteDataSource.getCategories();
      print('📦 Repository: Categories response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final categories = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${categories.length} categories');
        return Right(categories);
      } else {
        print('❌ Repository: Categories API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getCategories: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Categories not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getCategories: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 20}) async {
    try {
      print('🌐 Repository: Calling getProducts API (page: $page, limit: $limit)...');
      final response = await remoteDataSource.getProducts(page: page, limit: limit);
      print('🛍️ Repository: Products response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${products.length} products');
        return Right(products);
      } else {
        print('❌ Repository: Products API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in getProducts: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Products not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in getProducts: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({required String query, int page = 1, int limit = 20}) async {
    try {
      print('🔍 Repository: Calling searchProducts API (query: $query, page: $page, limit: $limit)...');
      final response = await remoteDataSource.searchProducts(query: query, page: page, limit: limit);
      print('🔍 Repository: Search response - success: ${response.success}, data count: ${response.data.length}');
      
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        print('✅ Repository: Mapped ${products.length} search results');
        return Right(products);
      } else {
        print('❌ Repository: Search API returned error: ${response.message}');
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      print('🚫 Repository: DioException in searchProducts: ${e.message}');
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('No products found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      print('💥 Repository: Unexpected error in searchProducts: $e');
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
