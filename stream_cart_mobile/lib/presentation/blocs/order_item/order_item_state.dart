import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/order_item_entity.dart';

abstract class OrderItemState extends Equatable {
  const OrderItemState();

  @override
  List<Object?> get props => [];
}

class OrderItemInitial extends OrderItemState {
  const OrderItemInitial();
}

class OrderItemLoading extends OrderItemState {
  const OrderItemLoading();
}

class OrderItemRefreshing extends OrderItemState {
  final List<OrderItemEntity> currentItems;

  const OrderItemRefreshing({required this.currentItems});

  @override
  List<Object?> get props => [currentItems];
}

class OrderItemByIdLoaded extends OrderItemState {
  final OrderItemEntity orderItem;

  const OrderItemByIdLoaded({required this.orderItem});

  @override
  List<Object?> get props => [orderItem];
}

class OrderItemsByOrderLoaded extends OrderItemState {
  final List<OrderItemEntity> orderItems;

  const OrderItemsByOrderLoaded({required this.orderItems});

  OrderItemsByOrderLoaded copyWith({
    List<OrderItemEntity>? orderItems,
  }) {
    return OrderItemsByOrderLoaded(
      orderItems: orderItems ?? this.orderItems,
    );
  }

  @override
  List<Object?> get props => [orderItems];
}

class OrderItemAdded extends OrderItemState {
  final OrderItemEntity orderItem;

  const OrderItemAdded({required this.orderItem});

  @override
  List<Object?> get props => [orderItem];
}

class OrderItemDeleted extends OrderItemState {
  final String deletedItemId;

  const OrderItemDeleted({required this.deletedItemId});

  @override
  List<Object?> get props => [deletedItemId];
}

class OrderItemQuantityUpdated extends OrderItemState {
  final String itemId;
  final int newQuantity;
  final List<OrderItemEntity> updatedItems;

  const OrderItemQuantityUpdated({
    required this.itemId,
    required this.newQuantity,
    required this.updatedItems,
  });

  @override
  List<Object?> get props => [itemId, newQuantity, updatedItems];
}

class OrderItemError extends OrderItemState {
  final String message;

  const OrderItemError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderItemOperationSuccess extends OrderItemState {
  final String message;

  const OrderItemOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}