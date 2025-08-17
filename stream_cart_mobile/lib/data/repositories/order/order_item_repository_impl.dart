import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/order/add_order_item_request_entity.dart';
import '../../../domain/entities/order/order_item_entity.dart';
import '../../../domain/repositories/order/order_item_repository.dart';
import '../../datasources/order/order_item_remote_data_source.dart';
import '../../models/order/add_order_item_request_model.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemRemoteDataSource remoteDataSource;

  OrderItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderItemEntity>> getOrderItemById(String id) async {
    try {
      final remoteOrderItem = await remoteDataSource.getOrderItemById(id);
      return Right(remoteOrderItem.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem chi tiết đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy sản phẩm trong đơn hàng'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'ID sản phẩm không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền xem sản phẩm này'));
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
  Future<Either<Failure, List<OrderItemEntity>>> getOrderItemsByOrderId(String orderId) async {
    try {
      final remoteOrderItems = await remoteDataSource.getOrderItemsByOrderId(orderId);
      return Right(remoteOrderItems.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách sản phẩm'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy sản phẩm nào trong đơn hàng này'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'ID đơn hàng không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền xem đơn hàng này'));
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
  Future<Either<Failure, OrderItemEntity>> addOrderItem(
    String orderId,
    AddOrderItemRequestEntity request,
  ) async {
    try {
      final requestModel = AddOrderItemRequestModel.fromEntity(request);
      final remoteOrderItem = await remoteDataSource.addOrderItem(orderId, requestModel);
      return Right(remoteOrderItem.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để thêm sản phẩm'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng hoặc sản phẩm'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Thông tin sản phẩm không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền thêm sản phẩm vào đơn hàng này'));
      } else if (e.response?.statusCode == 409) {
        return Left(ServerFailure('Sản phẩm đã có trong đơn hàng'));
      } else if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Không thể xử lý yêu cầu thêm sản phẩm';
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
  Future<Either<Failure, void>> deleteOrderItem(String id) async {
    try {
      await remoteDataSource.deleteOrderItem(id);
      return const Right(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xóa sản phẩm'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy sản phẩm cần xóa'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Không thể xóa sản phẩm này';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền xóa sản phẩm này'));
      } else if (e.response?.statusCode == 409) {
        return Left(ServerFailure('Đơn hàng đã được xử lý, không thể xóa sản phẩm'));
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