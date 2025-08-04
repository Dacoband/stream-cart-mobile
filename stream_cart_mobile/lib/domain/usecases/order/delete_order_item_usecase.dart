import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/order/order_item_repository.dart';

class DeleteOrderItemParams {
  final String id;

  DeleteOrderItemParams({required this.id});
}

class DeleteOrderItemUseCase {
  final OrderItemRepository repository;

  DeleteOrderItemUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteOrderItemParams params) async {
    return await repository.deleteOrderItem(params.id);
  }
}