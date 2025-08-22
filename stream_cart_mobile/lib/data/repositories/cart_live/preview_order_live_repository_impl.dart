import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/cart_live/preview_order_live_entity.dart';
import '../../../domain/repositories/cart_live/preview_order_live_repository.dart';
import '../../datasources/cart_live/preview_order_live_remote_data_source.dart';

class PreviewOrderLiveRepositoryImpl implements PreviewOrderLiveRepository {
	final PreviewOrderLiveRemoteDataSource remoteDataSource;

	PreviewOrderLiveRepositoryImpl(this.remoteDataSource);

	@override
	Future<Either<Failure, PreviewOrderLiveEntity>> getPreviewOrderLive(List<String> cartItemIds) async {
		try {
			if (cartItemIds.isEmpty) {
				return Left(ServerFailure('Danh sách sản phẩm trống'));
			}
			final remote = await remoteDataSource.getPreviewOrderLive(cartItemIds);
			return Right(remote.toEntity());
		} on DioException catch (e) {
			final status = e.response?.statusCode;
			if (status == 401) {
				return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem giỏ hàng live'));
			} else if (status == 404) {
				return Left(ServerFailure('Không tìm thấy giỏ hàng live hoặc sản phẩm'));
			} else if (status == 400) {
				final responseData = e.response?.data;
				final message = responseData?['message'] ?? 'Danh sách sản phẩm không hợp lệ';
				return Left(ServerFailure(message));
			} else if (status == 403) {
				return Left(ServerFailure('Không có quyền xem giỏ hàng live này'));
			} else if (status == 409) {
				return Left(ServerFailure('Trạng thái giỏ hàng không hợp lệ'));
			} else if (status == 422) {
				final responseData = e.response?.data;
				final message = responseData?['message'] ?? 'Không thể xử lý yêu cầu xem giỏ hàng live';
				return Left(ServerFailure(message));
			} else {
				return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
			}
		} on ServerException catch (e) {
			return Left(ServerFailure(e.message));
		} catch (e) {
			final msg = e.toString();
			final httpMatch = RegExp(r'HTTP (\\d{3})').firstMatch(msg);
			if (httpMatch != null) {
				final code = int.tryParse(httpMatch.group(1)!);
				switch (code) {
					case 401:
						return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem giỏ hàng live'));
					case 404:
						return Left(ServerFailure('Không tìm thấy giỏ hàng live hoặc sản phẩm'));
					case 400:
						return Left(ServerFailure('Danh sách sản phẩm không hợp lệ'));
					case 403:
						return Left(ServerFailure('Không có quyền xem giỏ hàng live này'));
					case 409:
						return Left(ServerFailure('Trạng thái giỏ hàng không hợp lệ'));
					case 422:
						return Left(ServerFailure('Không thể xử lý yêu cầu xem giỏ hàng live'));
				}
			}
			return Left(ServerFailure('Lỗi không xác định: $msg'));
		}
	}
}

