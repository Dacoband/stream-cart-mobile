import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/flash_sale_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/flash_sale_repository.dart';
import '../datasources/flash_sale_remote_data_source.dart';

class FlashSaleRepositoryImpl implements FlashSaleRepository {
  final FlashSaleRemoteDataSource remoteDataSource;

  FlashSaleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FlashSaleEntity>>> getFlashSales() async {
    try {
      final flashSaleModels = await remoteDataSource.getFlashSales();
      final flashSaleEntities = flashSaleModels.map((model) => model.toEntity()).toList();
      return Right(flashSaleEntities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getFlashSaleProduct(String productId) async {
    try {
      final productModel = await remoteDataSource.getFlashSaleProduct(productId);
      return Right(productModel.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFlashSaleProducts(List<String> productIds) async {
    try {
      final productModels = await remoteDataSource.getFlashSaleProducts(productIds);
      final productEntities = productModels.map((model) => model.toEntity()).toList();
      return Right(productEntities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
