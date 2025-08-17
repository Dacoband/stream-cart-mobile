import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class GetOrderByCodeParams {
  final String code;

  GetOrderByCodeParams({required this.code});
}

class GetOrderByCodeUseCase {
  final OrderRepository repository;

  GetOrderByCodeUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(GetOrderByCodeParams params) async {
    return await repository.getOrderDetailsByCode(params.code);
  }
}