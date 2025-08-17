import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class CancelOrderParams {
  final String id;

  CancelOrderParams({required this.id});
}

class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(CancelOrderParams params) async {
    return await repository.cancelOrder(params.id);
  }
}