import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/order/add_order_item_request_entity.dart';
import '../../entities/order/order_item_entity.dart';

abstract class OrderItemRepository {
  Future<Either<Failure, OrderItemEntity>> getOrderItemById(String id);
  Future<Either<Failure, List<OrderItemEntity>>> getOrderItemsByOrderId(String orderId);
  Future<Either<Failure, OrderItemEntity>> addOrderItem(String orderId, AddOrderItemRequestEntity request);
  Future<Either<Failure, void>> deleteOrderItem(String id);
}