import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class GetOrdersByAccountParams {
  final String accountId;
  final int? pageIndex;
  final int? pageSize;
  final int? status;

  GetOrdersByAccountParams({
    required this.accountId,
    this.pageIndex,
    this.pageSize,
    this.status,
  });
}

class GetOrdersByAccountUseCase {
  final OrderRepository repository;

  GetOrdersByAccountUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersByAccountParams params) async {
    return await repository.getOrdersByAccountId(
      params.accountId,
      pageIndex: params.pageIndex,
      pageSize: params.pageSize,
      status: params.status,
    );
  }
}