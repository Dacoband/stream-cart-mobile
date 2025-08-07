import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/deliveries/preview_deliveries_entity.dart';
import '../../../domain/entities/deliveries/preview_deliveries_response_entity.dart';
import '../../../domain/repositories/deliveries/deliveries_repository.dart';
import '../../datasources/deliveries/deliveries_remote_data_source.dart';
import '../../models/delivery/preview_deliveries_model.dart';

class DeliveriesRepositoryImpl implements DeliveriesRepository {
  final DeliveriesRemoteDataSource remoteDataSource;

  DeliveriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PreviewDeliveriesResponseEntity>> previewOrder(
    PreviewDeliveriesEntity request,
  ) async {
    try {
      final requestModel = PreviewDeliveriesModel.fromEntity(request);
      final responseModel = await remoteDataSource.previewOrder(requestModel);
      return Right(responseModel.toEntity());
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final message = (data is Map<String, dynamic> ? data['message'] : null)?.toString();

      if (status == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem ước tính phí vận chuyển'));
      } else if (status == 404) {
        return Left(ServerFailure('Không tìm thấy dịch vụ vận chuyển phù hợp'));
      } else if (status == 400) {
        return Left(ServerFailure(message ?? 'Thông tin địa chỉ hoặc sản phẩm không hợp lệ'));
      } else if (status == 403) {
        return Left(ServerFailure('Không có quyền thực hiện tính phí vận chuyển'));
      } else if (status == 409) {
        return Left(ServerFailure('Không thể xem trước do xung đột dữ liệu yêu cầu'));
      } else if (status == 422) {
        return Left(ServerFailure(message ?? 'Không thể xử lý yêu cầu xem trước đơn vận chuyển'));
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