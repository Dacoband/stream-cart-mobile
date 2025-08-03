import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/products/product_attribute_entity.dart';
import '../../../domain/repositories/product/product_attribute_repository.dart';
import '../../datasources/products/product_attribute_remote_data_source.dart';

class ProductAttributeRepositoryImpl implements ProductAttributeRepository {
  final ProductAttributeRemoteDataSource remoteDataSource;

  ProductAttributeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductAttributeEntity>>> getAllProductAttributes() async {
    try {
      final remoteProductAttributes = await remoteDataSource.getAllProductAttributes();
      return Right(remoteProductAttributes);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách thuộc tính'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy thuộc tính sản phẩm'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else {
        return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductAttributeEntity>> getProductAttributeById(String id) async {
    try {
      final remoteProductAttribute = await remoteDataSource.getProductAttributeById(id);
      return Right(remoteProductAttribute);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem thuộc tính sản phẩm'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy thuộc tính sản phẩm'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'ID không hợp lệ';
        return Left(ServerFailure(message));
      } else {
        return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductAttributeEntity>>> getProductAttributesByProduct(String productId) async {
    try {
      final remoteProductAttributes = await remoteDataSource.getProductAttributesByProduct(productId);
      return Right(remoteProductAttributes);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem thuộc tính sản phẩm'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy thuộc tính cho sản phẩm này'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Product ID không hợp lệ';
        return Left(ServerFailure(message));
      } else {
        return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductAttributeEntity>>> getProductAttributesWithValues(String Id) async {
    try {
      final remoteProductAttributes = await remoteDataSource.getProductAttributesWithValues();
      return Right(remoteProductAttributes);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem thuộc tính với giá trị'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy thuộc tính với giá trị'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else {
        return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }
}