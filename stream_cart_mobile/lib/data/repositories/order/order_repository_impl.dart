import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/order/create_order_request_entity.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/repositories/order/order_repository.dart';
import '../../datasources/order/order_remote_data_source.dart';
import '../../models/order/create_order_request_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByAccountId(
    String accountId, {
    int? status,
  }) async {
    try {
      final remoteOrders = await remoteDataSource.getOrdersByAccountId(
        accountId,
        status: status,
      );
      return Right(remoteOrders.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem danh sách đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng cho tài khoản này'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Yêu cầu không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền xem đơn hàng của tài khoản này'));
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
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final remoteOrder = await remoteDataSource.getOrderById(id);
      return Right(remoteOrder.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng'));
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
  Future<Either<Failure, OrderEntity>> getOrderDetailsByCode(String code) async {
    try {
      final remoteOrder = await remoteDataSource.getOrderByCode(code);
      return Right(remoteOrder.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để xem đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng với mã này'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Mã đơn hàng không hợp lệ';
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
  Future<Either<Failure, List<OrderEntity>>> createMultipleOrders(
    CreateOrderRequestEntity request,
  ) async {
    try {
      final requestModel = CreateOrderRequestModel.fromEntity(request);
      final remoteOrders = await remoteDataSource.createMultipleOrders(requestModel);
      return Right(remoteOrders.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để tạo đơn hàng'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Thông tin đơn hàng không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền tạo đơn hàng'));
      } else if (e.response?.statusCode == 409) {
        return Left(ServerFailure('Xung đột dữ liệu khi tạo đơn hàng'));
      } else if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Dữ liệu không thể xử lý';
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
  Future<Either<Failure, OrderEntity>> cancelOrder(String id) async {
    try {
      final remoteOrder = await remoteDataSource.cancelOrder(id);
      return Right(remoteOrder.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để hủy đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Không thể hủy đơn hàng này';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền hủy đơn hàng này'));
      } else if (e.response?.statusCode == 409) {
        return Left(ServerFailure('Đơn hàng đã được xử lý, không thể hủy'));
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
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String id, int status) async {
    try {
      final remoteOrder = await remoteDataSource.updateOrderStatus(id, status);
      return Right(remoteOrder.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure('Vui lòng đăng nhập để cập nhật trạng thái đơn hàng'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Không tìm thấy đơn hàng'));
      } else if (e.response?.statusCode == 400) {
        final responseData = e.response?.data;
        final message = responseData?['message'] ?? 'Trạng thái đơn hàng không hợp lệ';
        return Left(ServerFailure(message));
      } else if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Không có quyền cập nhật trạng thái đơn hàng này'));
      } else if (e.response?.statusCode == 409) {
        return Left(ServerFailure('Không thể cập nhật trạng thái đơn hàng hiện tại'));
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