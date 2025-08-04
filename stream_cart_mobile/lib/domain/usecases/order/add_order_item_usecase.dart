import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/add_order_item_request_entity.dart';
import '../../entities/order/order_item_entity.dart';
import '../../repositories/order/order_item_repository.dart';

class AddOrderItemParams {
  final String orderId;
  final AddOrderItemRequestEntity request;

  AddOrderItemParams({
    required this.orderId,
    required this.request,
  });
}

class AddOrderItemUseCase {
  final OrderItemRepository repository;

  AddOrderItemUseCase(this.repository);

  Future<Either<Failure, OrderItemEntity>> call(AddOrderItemParams params) async {
    return await repository.addOrderItem(params.orderId, params.request);
  }
}