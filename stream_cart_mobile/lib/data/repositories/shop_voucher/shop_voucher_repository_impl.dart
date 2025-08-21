import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/shop_voucher/shop_voucher_entity.dart';
import '../../../domain/repositories/shop_voucher/shop_voucher_repository.dart';
import '../../datasources/shop_voucher/shop_voucher_remote_data_source.dart';
import '../../models/shop_voucher/shop_voucher_model.dart';

class ShopVoucherRepositoryImpl implements ShopVoucherRepository {
	final ShopVoucherRemoteDataSource remoteDataSource;

	ShopVoucherRepositoryImpl(this.remoteDataSource);

	@override
	Future<Either<Failure, ShopVouchersResponseEntity>> getVouchers({
		required String shopId,
		bool? isActive,
		int? type,
		bool? isExpired,
		int pageNumber = 1,
		int pageSize = 10,
	}) async {
		try {
			final remoteResponse = await remoteDataSource.getVouchers(
				shopId: shopId,
				isActive: isActive,
				type: type,
				isExpired: isExpired,
				pageNumber: pageNumber,
				pageSize: pageSize,
			);
			return Right(remoteResponse.toEntity());
		} on DioException catch (e) {
			if (e.response?.statusCode == 401) {
				return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem voucher'));
			} else if (e.response?.statusCode == 404) {
				return Left(ServerFailure('Không tìm thấy voucher của shop'));
			} else if (e.response?.statusCode == 400) {
				final responseData = e.response?.data;
				final message = responseData?['message'] ?? 'Thông tin truy vấn không hợp lệ';
				return Left(ServerFailure(message));
			} else if (e.response?.statusCode == 403) {
				return Left(ServerFailure('Không có quyền xem voucher này'));
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
	Future<Either<Failure, ApplyShopVoucherResponseEntity>> applyVoucher({
		required String code,
		required ApplyShopVoucherRequestEntity request,
	}) async {
		try {
			final requestModel = ApplyShopVoucherRequestModel.fromEntity(request);
			final remoteResponse = await remoteDataSource.applyVoucher(
				code: code,
				request: requestModel,
			);
			return Right(remoteResponse.toEntity());
		} on DioException catch (e) {
			if (e.response?.statusCode == 401) {
				return Left(UnauthorizedFailure('Vui lòng đăng nhập để áp dụng voucher'));
			} else if (e.response?.statusCode == 404) {
				return Left(ServerFailure('Không tìm thấy voucher hoặc đơn hàng'));
			} else if (e.response?.statusCode == 400) {
				final responseData = e.response?.data;
				final message = responseData?['message'] ?? 'Thông tin voucher không hợp lệ';
				return Left(ServerFailure(message));
			} else if (e.response?.statusCode == 403) {
				return Left(ServerFailure('Không có quyền áp dụng voucher này'));
			} else if (e.response?.statusCode == 409) {
				return Left(ServerFailure('Voucher đã được sử dụng hoặc không hợp lệ'));
			} else if (e.response?.statusCode == 422) {
				final responseData = e.response?.data;
				final message = responseData?['message'] ?? 'Không thể xử lý yêu cầu áp dụng voucher';
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
