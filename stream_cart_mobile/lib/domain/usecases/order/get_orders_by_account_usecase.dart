import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order/order_repository.dart';

class GetOrdersByAccountParams extends Equatable {
  final String accountId;
  final int? status;

  const GetOrdersByAccountParams({
    required this.accountId,
    this.status,
  });

  @override
  List<Object?> get props => [accountId, status];
}

class GetOrdersByAccountUseCase {
  final OrderRepository repository;

  GetOrdersByAccountUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersByAccountParams params) async {
    return await repository.getOrdersByAccountId(
      params.accountId,
      status: params.status,
    );
  }
}