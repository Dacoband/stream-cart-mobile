import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class GetOrderByIdParams {
  final String id;

  GetOrderByIdParams({required this.id});
}

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(GetOrderByIdParams params) async {
    return await repository.getOrderById(params.id);
  }
}