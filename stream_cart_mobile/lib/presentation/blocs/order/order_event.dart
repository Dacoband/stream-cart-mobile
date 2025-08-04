import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/create_order_request_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class GetOrdersByAccountEvent extends OrderEvent {
  final String accountId;
  final int? status;

  const GetOrdersByAccountEvent({
    required this.accountId,
    this.status,
  });

  @override
  List<Object?> get props => [accountId, status];
}

class GetOrderByIdEvent extends OrderEvent {
  final String id;

  const GetOrderByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetOrderByCodeEvent extends OrderEvent {
  final String code;

  const GetOrderByCodeEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class CreateMultipleOrdersEvent extends OrderEvent {
  final CreateOrderRequestEntity request;

  const CreateMultipleOrdersEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class CancelOrderEvent extends OrderEvent {
  final String id;

  const CancelOrderEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class RefreshOrdersEvent extends OrderEvent {
  final String accountId;
  final int? status;

  const RefreshOrdersEvent({
    required this.accountId,
    this.status,
  });

  @override
  List<Object?> get props => [accountId, status];
}

class LoadMoreOrdersEvent extends OrderEvent {
  final String accountId;
  final int? status;

  const LoadMoreOrdersEvent({
    required this.accountId,
    this.status,
  });

  @override
  List<Object?> get props => [accountId, status];
}

class ResetOrderStateEvent extends OrderEvent {
  const ResetOrderStateEvent();

  @override
  List<Object?> get props => [];
}