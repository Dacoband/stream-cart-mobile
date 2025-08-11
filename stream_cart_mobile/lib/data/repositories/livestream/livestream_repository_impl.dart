import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/livestream/livestream_entity.dart';
import '../../../domain/repositories/livestream/livestream_repository.dart';
import '../../datasources/livestream/livestream_remote_data_source.dart';

class LiveStreamRepositoryImpl implements LiveStreamRepository {
	final LiveStreamRemoteDataSource remoteDataSource;

	LiveStreamRepositoryImpl(this.remoteDataSource);

	@override
	Future<Either<Failure, LiveStreamEntity>> getLiveStream(String id) async {
		try {
			final model = await remoteDataSource.getLiveStream(id);
			return Right(model.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e, customNotFound: 'Không tìm thấy livestream'));
		} on ServerException catch (e) {
			return Left(ServerFailure(e.message));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
		}
	}

	@override
	Future<Either<Failure, LiveStreamEntity>> joinLiveStream(String id) async {
		try {
			final model = await remoteDataSource.joinLiveStream(id);
			return Right(model.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					customNotFound: 'Livestream không tồn tại',
					customForbidden: 'Bạn không có quyền tham gia livestream này'));
		} on ServerException catch (e) {
			return Left(ServerFailure(e.message));
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
		}
	}

	@override
	Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreamsByShop(String shopId) async {
		try {
			final models = await remoteDataSource.getLiveStreamsByShop(shopId);
			return Right(models.map((m) => m.toEntity()).toList());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e, customNotFound: 'Shop không có livestream nào'));
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
