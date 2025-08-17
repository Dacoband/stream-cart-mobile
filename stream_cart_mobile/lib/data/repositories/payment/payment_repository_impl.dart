import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/payment/payment_entity.dart';
import '../../../domain/repositories/payment/payment_repository.dart';
import '../../datasources/payment/payment_remote_data_source.dart';
import '../../models/payment/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
	final PaymentRemoteDataSource remoteDataSource;

	PaymentRepositoryImpl({required this.remoteDataSource});

	@override
	Future<Either<Failure, PaymentQrEntity>> generatePaymentQr(
			GeneratePaymentQrRequestEntity request) async {
		try {
			final model = GeneratePaymentQrRequestModel.fromEntity(request);
			final result = await remoteDataSource.generatePaymentQr(model);
			return Right(result.toEntity());
		} on DioException catch (e) {
			final status = e.response?.statusCode;
			final responseData = e.response?.data;
			final dynamic messageRaw = (responseData is Map) ? responseData['message'] : null;
			final msg = (messageRaw is String && messageRaw.isNotEmpty)
					? messageRaw
					: 'Không thể tạo mã QR thanh toán';

			if (status == 401) {
				return Left(UnauthorizedFailure('Vui lòng đăng nhập để tạo thanh toán'));
			} else if (status == 404) {
				return Left(ServerFailure('Không tìm thấy đơn hàng để thanh toán'));
			} else if (status == 400) {
				return Left(ServerFailure(msg));
			} else if (status == 403) {
				return Left(ServerFailure('Không có quyền tạo thanh toán cho đơn hàng này'));
			} else if (status == 409) {
				return Left(ConflictFailure('Trạng thái đơn hàng không hợp lệ để thanh toán'));
			} else if (status == 422) {
				return Left(ServerFailure(msg));
			} else if (status == 429) {
				return Left(TooManyRequestsFailure('Thao tác quá nhanh, thử lại sau'));
			} else if (e.type == DioExceptionType.connectionTimeout ||
					e.type == DioExceptionType.receiveTimeout ||
					e.type == DioExceptionType.sendTimeout ||
					e.type == DioExceptionType.connectionError) {
				return Left(NetworkFailure('Lỗi kết nối: ${e.message}'));
			} else {
				return Left(ServerFailure('Lỗi máy chủ: ${e.message}'));
			}
		} catch (e) {
			return Left(ServerFailure('Lỗi không xác định: ${e.toString()}'));
		}
	}
}

