import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order/order_item_entity.dart';
import '../../../domain/usecases/order/get_order_item_by_id_usecase.dart';
import '../../../domain/usecases/order/get_order_items_by_order_usecase.dart';
import '../../../domain/usecases/order/add_order_item_usecase.dart';
import '../../../domain/usecases/order/delete_order_item_usecase.dart';
import 'order_item_event.dart';
import 'order_item_state.dart';

class OrderItemBloc extends Bloc<OrderItemEvent, OrderItemState> {
  final GetOrderItemByIdUseCase _getOrderItemByIdUseCase;
  final GetOrderItemsByOrderUseCase _getOrderItemsByOrderUseCase;
  final AddOrderItemUseCase _addOrderItemUseCase;
  final DeleteOrderItemUseCase _deleteOrderItemUseCase;

  List<OrderItemEntity> _currentOrderItems = [];

  OrderItemBloc({
    required GetOrderItemByIdUseCase getOrderItemByIdUseCase,
    required GetOrderItemsByOrderUseCase getOrderItemsByOrderUseCase,
    required AddOrderItemUseCase addOrderItemUseCase,
    required DeleteOrderItemUseCase deleteOrderItemUseCase,
  })  : _getOrderItemByIdUseCase = getOrderItemByIdUseCase,
        _getOrderItemsByOrderUseCase = getOrderItemsByOrderUseCase,
        _addOrderItemUseCase = addOrderItemUseCase,
        _deleteOrderItemUseCase = deleteOrderItemUseCase,
        super(const OrderItemInitial()) {
    
    on<GetOrderItemByIdEvent>(_onGetOrderItemById);
    on<GetOrderItemsByOrderEvent>(_onGetOrderItemsByOrder);
    on<AddOrderItemEvent>(_onAddOrderItem);
    on<DeleteOrderItemEvent>(_onDeleteOrderItem);
    on<RefreshOrderItemsEvent>(_onRefreshOrderItems);
    on<UpdateOrderItemQuantityEvent>(_onUpdateOrderItemQuantity);
    on<ResetOrderItemStateEvent>(_onResetOrderItemState);
  }

  Future<void> _onGetOrderItemById(
    GetOrderItemByIdEvent event,
    Emitter<OrderItemState> emit,
  ) async {
    emit(const OrderItemLoading());

    final result = await _getOrderItemByIdUseCase(
      GetOrderItemByIdParams(id: event.id),
    );

    result.fold(
      (failure) => emit(OrderItemError(message: failure.message)),
      (orderItem) => emit(OrderItemByIdLoaded(orderItem: orderItem)),
    );
  }

  Future<void> _onGetOrderItemsByOrder(
    GetOrderItemsByOrderEvent event,
    Emitter<OrderItemState> emit,
  ) async {
    emit(const OrderItemLoading());

    final result = await _getOrderItemsByOrderUseCase(
      GetOrderItemsByOrderParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(OrderItemError(message: failure.message)),
      (orderItems) {
        _currentOrderItems = orderItems;
        emit(OrderItemsByOrderLoaded(orderItems: orderItems));
      },
    );
  }

  Future<void> _onAddOrderItem(
    AddOrderItemEvent event,
    Emitter<OrderItemState> emit,
  ) async {
    emit(const OrderItemLoading());

    final result = await _addOrderItemUseCase(
      AddOrderItemParams(
        orderId: event.orderId,
        request: event.request,
      ),
    );

    result.fold(
      (failure) => emit(OrderItemError(message: failure.message)),
      (orderItem) {
        // Update local list
        _currentOrderItems.add(orderItem);
        
        emit(OrderItemAdded(orderItem: orderItem));
        emit(const OrderItemOperationSuccess(message: 'Sản phẩm đã được thêm vào đơn hàng'));
        
        // Emit updated list
        emit(OrderItemsByOrderLoaded(orderItems: List.from(_currentOrderItems)));
      },
    );
  }

  Future<void> _onDeleteOrderItem(
    DeleteOrderItemEvent event,
    Emitter<OrderItemState> emit,
  ) async {
    emit(const OrderItemLoading());

    final result = await _deleteOrderItemUseCase(
      DeleteOrderItemParams(id: event.id),
    );

    result.fold(
      (failure) => emit(OrderItemError(message: failure.message)),
      (_) {
        // Update local list
        _currentOrderItems.removeWhere((item) => item.id == event.id);
        
        emit(OrderItemDeleted(deletedItemId: event.id));
        emit(const OrderItemOperationSuccess(message: 'Sản phẩm đã được xóa khỏi đơn hàng'));
        
        // Emit updated list
        emit(OrderItemsByOrderLoaded(orderItems: List.from(_currentOrderItems)));
      },
    );
  }

  Future<void> _onRefreshOrderItems(
    RefreshOrderItemsEvent event,
    Emitter<OrderItemState> emit,
  ) async {
    if (state is OrderItemsByOrderLoaded) {
      final currentState = state as OrderItemsByOrderLoaded;
      emit(OrderItemRefreshing(currentItems: currentState.orderItems));
    }

    final result = await _getOrderItemsByOrderUseCase(
      GetOrderItemsByOrderParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(OrderItemError(message: failure.message)),
      (orderItems) {
        _currentOrderItems = orderItems;
        emit(OrderItemsByOrderLoaded(orderItems: orderItems));
      },
    );
  }

  void _onUpdateOrderItemQuantity(
    UpdateOrderItemQuantityEvent event,
    Emitter<OrderItemState> emit,
  ) {
    // Local update for immediate UI feedback
    final updatedItems = _currentOrderItems.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: event.newQuantity);
      }
      return item;
    }).toList();

    _currentOrderItems = updatedItems;

    emit(OrderItemQuantityUpdated(
      itemId: event.itemId,
      newQuantity: event.newQuantity,
      updatedItems: updatedItems,
    ));

    // Emit updated list state
    emit(OrderItemsByOrderLoaded(orderItems: List.from(updatedItems)));
  }

  void _onResetOrderItemState(
    ResetOrderItemStateEvent event,
    Emitter<OrderItemState> emit,
  ) {
    _currentOrderItems.clear();
    emit(const OrderItemInitial());
  }
}