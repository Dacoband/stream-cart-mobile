import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/products/attribute_value_entity.dart';
import '../../../domain/repositories/product/attribute_value_repository.dart';
import '../../datasources/products/attribute_value_remote_data_source.dart';

class AttributeValueRepositoryImpl implements AttributeValueRepository {
  final AttributeValueRemoteDataSource remoteDataSource;

  AttributeValueRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AttributeValueEntity>>> getAllAttributeValues() async {
    try {
      final remoteAttributeValues = await remoteDataSource.getAllAttributeValues();
      return Right(remoteAttributeValues);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách giá trị thuộc tính'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy giá trị thuộc tính'));
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
  Future<Either<Failure, AttributeValueEntity>> getAttributeValueById(String id) async {
    try {
      final remoteAttributeValue = await remoteDataSource.getAttributeValueById(id);
      return Right(remoteAttributeValue);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem giá trị thuộc tính'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy giá trị thuộc tính'));
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
  Future<Either<Failure, List<AttributeValueEntity>>> getAttributeValuesByAttribute(String attributeId) async {
    try {
      final remoteAttributeValues = await remoteDataSource.getAttributeValuesByAttribute(attributeId);
      return Right(remoteAttributeValues);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem giá trị thuộc tính'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy giá trị cho thuộc tính này'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Attribute ID không hợp lệ';
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