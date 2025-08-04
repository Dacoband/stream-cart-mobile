import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_item_entity.dart';
import '../../repositories/order/order_item_repository.dart';

class GetOrderItemByIdParams {
  final String id;

  GetOrderItemByIdParams({required this.id});
}

class GetOrderItemByIdUseCase {
  final OrderItemRepository repository;

  GetOrderItemByIdUseCase(this.repository);

  Future<Either<Failure, OrderItemEntity>> call(GetOrderItemByIdParams params) async {
    return await repository.getOrderItemById(params.id);
  }
}