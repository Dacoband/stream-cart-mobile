import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/add_order_item_request_entity.dart';

abstract class OrderItemEvent extends Equatable {
  const OrderItemEvent();

  @override
  List<Object?> get props => [];
}

class GetOrderItemByIdEvent extends OrderItemEvent {
  final String id;

  const GetOrderItemByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetOrderItemsByOrderEvent extends OrderItemEvent {
  final String orderId;

  const GetOrderItemsByOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class AddOrderItemEvent extends OrderItemEvent {
  final String orderId;
  final AddOrderItemRequestEntity request;

  const AddOrderItemEvent({
    required this.orderId,
    required this.request,
  });

  @override
  List<Object?> get props => [orderId, request];
}

class DeleteOrderItemEvent extends OrderItemEvent {
  final String id;

  const DeleteOrderItemEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class RefreshOrderItemsEvent extends OrderItemEvent {
  final String orderId;

  const RefreshOrderItemsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ResetOrderItemStateEvent extends OrderItemEvent {
  const ResetOrderItemStateEvent();
}

class UpdateOrderItemQuantityEvent extends OrderItemEvent {
  final String itemId;
  final int newQuantity;

  const UpdateOrderItemQuantityEvent({
    required this.itemId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [itemId, newQuantity];
}