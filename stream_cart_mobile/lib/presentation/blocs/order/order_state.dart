import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoadingMore extends OrderState {
  final List<OrderEntity> currentOrders;

  const OrderLoadingMore({required this.currentOrders});

  @override
  List<Object?> get props => [currentOrders];
}

class OrderRefreshing extends OrderState {
  final List<OrderEntity> currentOrders;

  const OrderRefreshing({required this.currentOrders});

  @override
  List<Object?> get props => [currentOrders];
}

class OrdersByAccountLoaded extends OrderState {
  final List<OrderEntity> orders;
  final bool hasReachedMax;
  final int currentPage;

  const OrdersByAccountLoaded({
    required this.orders,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  OrdersByAccountLoaded copyWith({
    List<OrderEntity>? orders,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return OrdersByAccountLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [orders, hasReachedMax, currentPage];
}

class OrderByIdLoaded extends OrderState {
  final OrderEntity order;

  const OrderByIdLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderByCodeLoaded extends OrderState {
  final OrderEntity order;

  const OrderByCodeLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrdersCreated extends OrderState {
  final List<OrderEntity> orders;

  const OrdersCreated({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderCancelled extends OrderState {
  final OrderEntity order;

  const OrderCancelled({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderOperationSuccess extends OrderState {
  final String message;

  const OrderOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}