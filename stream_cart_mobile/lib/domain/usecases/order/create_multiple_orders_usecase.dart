import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/create_order_request_entity.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class CreateMultipleOrdersParams {
  final CreateOrderRequestEntity request;

  CreateMultipleOrdersParams({required this.request});
}

class CreateMultipleOrdersUseCase {
  final OrderRepository repository;

  CreateMultipleOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(CreateMultipleOrdersParams params) async {
    return await repository.createMultipleOrders(params.request);
  }
}