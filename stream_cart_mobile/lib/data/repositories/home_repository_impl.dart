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
      final response = await remoteDataSource.getCategories();
      if (response.success) {
        final categories = response.data.map((model) => model.toEntity()).toList();
        return Right(categories);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Categories not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final response = await remoteDataSource.getProducts(page: page, limit: limit);
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Products not found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({required String query, int page = 1, int limit = 20}) async {
    try {
      final response = await remoteDataSource.searchProducts(query: query, page: page, limit: limit);
      if (response.success) {
        final products = response.data.map((model) => model.toEntity()).toList();
        return Right(products);
      } else {
        return Left(ServerFailure(response.message));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access'));      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('No products found'));
      } else {
        return Left(NetworkFailure('Network error occurred'));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
