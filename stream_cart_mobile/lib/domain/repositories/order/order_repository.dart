import 'package:dartz/dartz.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';
import 'package:stream_cart_mobile/domain/entities/order/order_entity.dart';

import '../../entities/order/create_order_request_entity.dart';

abstract class OrderRepository {
  // GET /api/orders/{id}
  Future<Either<Failure, OrderEntity>> getOrderById(String id);
  // POST /api/orders/multi
  Future<Either<Failure, List<OrderEntity>>> createMultipleOrders(CreateOrderRequestEntity request);
  // POST /api/orders/{id}/cancel
  Future<Either<Failure, OrderEntity>> cancelOrder(String id);
  // GET /api/orders/account/{accountId}
  Future<Either<Failure, List<OrderEntity>>> getOrdersByAccountId(
    String accountId, {
    int? status,
  });
  //Get order details by order code
  Future<Either<Failure, OrderEntity>> getOrderDetailsByCode(String code);
}