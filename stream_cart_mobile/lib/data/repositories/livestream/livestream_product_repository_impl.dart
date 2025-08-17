import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/livestream/livestream_product_entity.dart';
import '../../../domain/repositories/livestream/livestream_product_repository.dart';
import '../../datasources/livestream/livestream_product_remote_data_source.dart';

class LiveStreamProductRepositoryImpl implements LiveStreamProductRepository {
	final LiveStreamProductRemoteDataSource remoteDataSource;

	LiveStreamProductRepositoryImpl(this.remoteDataSource);

	@override
	Future<Either<Failure, List<LiveStreamProductEntity>>> getProductsByLiveStream(String liveStreamId) async {
		try {
			final models = await remoteDataSource.getProductsByLiveStream(liveStreamId);
			return Right(models.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e, customNotFound: 'Không tìm thấy sản phẩm của livestream')); 
		} on ServerException catch (e) {
			return Left(ServerFailure(e.message));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
		}
	}

	@override
	Future<Either<Failure, List<LiveStreamProductEntity>>> getPinnedProductsByLiveStream(String liveStreamId, {int? limit}) async {
		try {
			final models = await remoteDataSource.getPinnedProductsByLiveStream(liveStreamId, limit: limit);
			return Right(models.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e, customNotFound: 'Không tìm thấy sản phẩm được ghim'));
		} on ServerException catch (e) {
			return Left(ServerFailure(e.message));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
		}
	}

	Failure _mapDioToFailure(
		DioException e, {
		String? customBadRequest,
		String? customUnauthorized,
		String? customForbidden,
		String? customNotFound,
	}) {
		final status = e.response?.statusCode;
		final dataMessage = e.response?.data is Map<String, dynamic>
				? e.response?.data['message'] as String?
				: null;
		switch (status) {
			case 400:
				return ServerFailure(customBadRequest ?? dataMessage ?? 'Yêu cầu không hợp lệ');
			case 401:
				return UnauthorizedFailure(customUnauthorized ?? 'Vui lòng đăng nhập');
			case 403:
				return ServerFailure(customForbidden ?? 'Không có quyền truy cập');
			case 404:
				return ServerFailure(customNotFound ?? 'Không tìm thấy dữ liệu');
			case 409:
				return ServerFailure(dataMessage ?? 'Xung đột dữ liệu');
			case 422:
				return ServerFailure(dataMessage ?? 'Không thể xử lý yêu cầu');
			default:
				return NetworkFailure('Lỗi kết nối: ${e.message}');
		}
	}
}
