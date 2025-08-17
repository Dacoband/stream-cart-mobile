import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_item_entity.dart';
import '../../repositories/order/order_item_repository.dart';

class GetOrderItemsByOrderParams {
  final String orderId;

  GetOrderItemsByOrderParams({required this.orderId});
}

class GetOrderItemsByOrderUseCase {
  final OrderItemRepository repository;

  GetOrderItemsByOrderUseCase(this.repository);

  Future<Either<Failure, List<OrderItemEntity>>> call(GetOrderItemsByOrderParams params) async {
    return await repository.getOrderItemsByOrderId(params.orderId);
  }
}