import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/usecases/order/get_orders_by_account_usecase.dart';
import '../../../domain/usecases/order/get_order_by_id_usecase.dart';
import '../../../domain/usecases/order/get_order_by_code_usecase.dart';
import '../../../domain/usecases/order/create_multiple_orders_usecase.dart';
import '../../../domain/usecases/order/cancel_order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersByAccountUseCase _getOrdersByAccountUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final GetOrderByCodeUseCase _getOrderByCodeUseCase;
  final CreateMultipleOrdersUseCase _createMultipleOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  static const int _pageSize = 10;
  List<OrderEntity> _allOrders = [];
  int _currentPage = 0;
  bool _hasReachedMax = false;

  OrderBloc({
    required GetOrdersByAccountUseCase getOrdersByAccountUseCase,
    required GetOrderByIdUseCase getOrderByIdUseCase,
    required GetOrderByCodeUseCase getOrderByCodeUseCase,
    required CreateMultipleOrdersUseCase createMultipleOrdersUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _getOrdersByAccountUseCase = getOrdersByAccountUseCase,
        _getOrderByIdUseCase = getOrderByIdUseCase,
        _getOrderByCodeUseCase = getOrderByCodeUseCase,
        _createMultipleOrdersUseCase = createMultipleOrdersUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        super(const OrderInitial()) {
    
    on<GetOrdersByAccountEvent>(_onGetOrdersByAccount);
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<GetOrderByCodeEvent>(_onGetOrderByCode);
    on<CreateMultipleOrdersEvent>(_onCreateMultipleOrders);
    on<CancelOrderEvent>(_onCancelOrder);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<LoadMoreOrdersEvent>(_onLoadMoreOrders);
    on<ResetOrderStateEvent>(_onResetOrderState);
  }

  Future<void> _onGetOrdersByAccount(
    GetOrdersByAccountEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    
    _currentPage = 0;
    _hasReachedMax = false;
    _allOrders.clear();

    final result = await _getOrdersByAccountUseCase(
      GetOrdersByAccountParams(
        accountId: event.accountId,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) {
        _allOrders = orders;
        _hasReachedMax = orders.length < _pageSize;
        emit(OrdersByAccountLoaded(
          orders: _allOrders,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
        ));
      },
    );
  }

  Future<void> _onGetOrderById(
    GetOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await _getOrderByIdUseCase(
      GetOrderByIdParams(id: event.id),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderByIdLoaded(order: order)),
    );
  }

  Future<void> _onGetOrderByCode(
    GetOrderByCodeEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await _getOrderByCodeUseCase(
      GetOrderByCodeParams(code: event.code),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderByCodeLoaded(order: order)),
    );
  }

  Future<void> _onCreateMultipleOrders(
    CreateMultipleOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await _createMultipleOrdersUseCase(
      CreateMultipleOrdersParams(request: event.request),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) {
        emit(OrdersCreated(orders: orders));
        emit(const OrderOperationSuccess(message: 'Đơn hàng đã được tạo thành công'));
      },
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await _cancelOrderUseCase(
      CancelOrderParams(id: event.id),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) {
        // Update local order list if exists
        final orderIndex = _allOrders.indexWhere((o) => o.id == order.id);
        if (orderIndex != -1) {
          _allOrders[orderIndex] = order;
        }
        
        emit(OrderCancelled(order: order));
        emit(const OrderOperationSuccess(message: 'Đơn hàng đã được hủy thành công'));
      },
    );
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (state is OrdersByAccountLoaded) {
      final currentState = state as OrdersByAccountLoaded;
      emit(OrderRefreshing(currentOrders: currentState.orders));
    }

    _currentPage = 0;
    _hasReachedMax = false;

    final result = await _getOrdersByAccountUseCase(
      GetOrdersByAccountParams(
        accountId: event.accountId,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) {
        _allOrders = orders;
        _hasReachedMax = orders.length < _pageSize;
        emit(OrdersByAccountLoaded(
          orders: _allOrders,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
        ));
      },
    );
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (_hasReachedMax) return;

    if (state is OrdersByAccountLoaded) {
      final currentState = state as OrdersByAccountLoaded;
      emit(OrderLoadingMore(currentOrders: currentState.orders));
    }

    _currentPage++;

    final result = await _getOrdersByAccountUseCase(
      GetOrdersByAccountParams(
        accountId: event.accountId,
        status: event.status,
      ),
    );

    result.fold(
      (failure) {
        _currentPage--; // Rollback page on error
        emit(OrderError(message: failure.message));
      },
      (orders) {
        _hasReachedMax = orders.length < _pageSize;
        _allOrders.addAll(orders);
        emit(OrdersByAccountLoaded(
          orders: _allOrders,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage,
        ));
      },
    );
  }

  void _onResetOrderState(
    ResetOrderStateEvent event,
    Emitter<OrderState> emit,
  ) {
    _allOrders.clear();
    _currentPage = 0;
    _hasReachedMax = false;
    emit(const OrderInitial());
  }
}