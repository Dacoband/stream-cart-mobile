import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/products/product_variants_entity.dart';
import '../../../domain/repositories/product/product_variants_repository.dart';
import '../../datasources/products/product_variants_remote_data_source.dart';

class ProductVariantsRepositoryImpl implements ProductVariantsRepository {
  final ProductVariantsRemoteDataSource remoteDataSource;

  ProductVariantsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> getProductVariants() async {
    try {
      final remoteProductVariants = await remoteDataSource.getProductVariants();
      return Right(remoteProductVariants);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách variants'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy product variants'));
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
  Future<Either<Failure, ProductVariantEntity>> getProductVariantById(String id) async {
    try {
      final remoteProductVariant = await remoteDataSource.getProductVariantById(id);
      return Right(remoteProductVariant);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem product variant'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy product variant'));
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
  Future<Either<Failure, List<ProductVariantEntity>>> getProductVariantsByProductId(String productId) async {
    try {
      final remoteProductVariants = await remoteDataSource.getProductVariantsByProductId(productId);
      return Right(remoteProductVariants);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem product variants'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy variants cho sản phẩm này'));
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
  Future<Either<Failure, ProductVariantEntity>> updateProductVariantPrice(String id, double price) async {
    try {
      final updatedProductVariant = await remoteDataSource.updateProductVariantPrice(id, price);
      return Right(updatedProductVariant);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để cập nhật giá'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy product variant'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Giá không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền cập nhật giá sản phẩm'));
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
  Future<Either<Failure, ProductVariantEntity>> updateProductVariantStock(String id, int stock) async {
    try {
      final updatedProductVariant = await remoteDataSource.updateProductVariantStock(id, stock);
      return Right(updatedProductVariant);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để cập nhật stock'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy product variant'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Số lượng không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền cập nhật stock sản phẩm'));
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