import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/livestream/livestream_message_entity.dart';
import '../../../domain/repositories/livestream/livestream_message_repository.dart';
import '../../datasources/livestream/livestream_message_remote_data_source.dart';

class LiveStreamMessageRepositoryImpl implements LiveStreamMessageRepository {
	final LiveStreamMessageRemoteDataSource remoteDataSource;

	LiveStreamMessageRepositoryImpl(this.remoteDataSource);

	@override
	Future<Either<Failure, LiveStreamChatMessageEntity>> joinChatLiveStream(String livestreamId) async {
		try {
			final model = await remoteDataSource.joinChat(livestreamId);
			return Right(model.toEntity());
		} on DioException catch (e) {
			return Left(_mapDioToFailure(e,
					customNotFound: 'Không tìm thấy livestream',
					customForbidden: 'Không có quyền tham gia chat livestream này'));
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
