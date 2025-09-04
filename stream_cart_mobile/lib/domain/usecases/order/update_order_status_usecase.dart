import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class UpdateOrderStatusParams {
  final String orderId;
  final int status;

  UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
  });
}

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(UpdateOrderStatusParams params) async {
    return await repository.updateOrderStatus(params.orderId, params.status);
  }
}
