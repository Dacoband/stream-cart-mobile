import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/get_cart_items_usecase.dart';
import '../../../domain/usecases/update_cart_item_usecase.dart';
import '../../../domain/usecases/remove_from_cart_usecase.dart';
import '../../../domain/usecases/clear_cart_usecase.dart';
import '../../../domain/usecases/get_cart_preview_usecase.dart';
import '../../../domain/usecases/get_preview_order_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartPreviewUseCase getCartPreviewUseCase;
  final GetPreviewOrderUseCase getPreviewOrderUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.getCartItemsUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.getCartPreviewUseCase,
    required this.getPreviewOrderUseCase,
  }) : super(CartInitial()) {
    print('Creating CartBloc instance: ${hashCode}'); // Debug log
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<GetCartPreviewEvent>(_onGetCartPreview);
    on<ToggleCartItemSelectionEvent>(_onToggleCartItemSelection);
    on<SelectAllCartItemsEvent>(_onSelectAllCartItems);
    on<UnselectAllCartItemsEvent>(_onUnselectAllCartItems);
    on<GetSelectedItemsPreviewEvent>(_onGetSelectedItemsPreview);
    print('CartBloc ${hashCode} event handlers registered'); // Debug log
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final result = await getCartItemsUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cartItems) {
        // Calculate total amount from cart items
        double totalAmount = 0;
        for (var item in cartItems) {
          totalAmount += (item.currentPrice * item.quantity);
        }
        emit(CartLoaded(
          items: cartItems, 
          totalAmount: totalAmount,
          selectedCartItemIds: const {}, // Khởi tạo với set rỗng
        ));
      },
    );
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final params = AddToCartParams(
      productId: event.productId,
      variantId: event.variantId,
      quantity: event.quantity,
    );
    
    final result = await addToCartUseCase(params);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (response) {
        if (response.success) {
          emit(CartItemAdded(response.message));
          // Reload cart after adding item
          add(LoadCartEvent());
        } else {
          emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Lỗi không xác định'));
        }
      },
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    // Get current state để update ngay lập tức
    final currentState = state;
    if (currentState is! CartLoaded) {
      // If not loaded, do full reload
      emit(CartLoading());
      add(LoadCartEvent());
      return;
    }

    // Update local state immediately for smooth UX
    final updatedItems = currentState.items.map((item) {
      if (item.cartItemId == event.cartItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    // Calculate new total amount
    double newTotalAmount = 0;
    for (var item in updatedItems) {
      newTotalAmount += (item.currentPrice * item.quantity);
    }

    // Emit updated state immediately
    emit(CartLoaded(items: updatedItems, totalAmount: newTotalAmount));

    // Call API in background
    final params = UpdateCartItemParams(
      productId: event.productId,
      variantId: event.variantId,
      quantity: event.quantity,
    );
    
    final result = await updateCartItemUseCase(params);
    result.fold(
      (failure) {
        // If API fails, revert to original state and show error
        emit(currentState);
        emit(CartError(failure.message));
      },
      (response) {
        if (!response.success) {
          // If API returns error, revert and show error
          emit(currentState);
          emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Cập nhật không thành công'));
        }
        // If success, keep the updated state (already emitted above)
      },
    );
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final params = RemoveFromCartParams(
      productId: event.productId,
      variantId: event.variantId,
    );
    
    final result = await removeFromCartUseCase(params);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) {
        emit(const CartItemRemoved('Đã xóa sản phẩm khỏi giỏ hàng'));
        // Reload cart after removing item
        add(LoadCartEvent());
      },
    );
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final result = await clearCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) {
        emit(const CartCleared('Đã xóa tất cả sản phẩm khỏi giỏ hàng'));
        // Reload cart after clearing
        add(LoadCartEvent());
      },
    );
  }

  Future<void> _onGetCartPreview(GetCartPreviewEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final result = await getCartPreviewUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartPreviewLoaded(cart)),
    );
  }

  // Selection handlers
  void _onToggleCartItemSelection(ToggleCartItemSelectionEvent event, Emitter<CartState> emit) {
    print('_onToggleCartItemSelection called for: ${event.cartItemId}'); // Debug log
    final currentState = state;
    if (currentState is! CartLoaded) {
      print('Current state is not CartLoaded: ${currentState.runtimeType}'); // Debug log
      return;
    }

    final newSelectedItems = Set<String>.from(currentState.selectedCartItemIds);
    if (newSelectedItems.contains(event.cartItemId)) {
      newSelectedItems.remove(event.cartItemId);
      print('Removed item from selection: ${event.cartItemId}'); // Debug log
    } else {
      newSelectedItems.add(event.cartItemId);
      print('Added item to selection: ${event.cartItemId}'); // Debug log
    }

    print('New selected items: $newSelectedItems'); // Debug log
    emit(currentState.copyWith(selectedCartItemIds: newSelectedItems));
  }

  void _onSelectAllCartItems(SelectAllCartItemsEvent event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final allCartItemIds = currentState.items.map((item) => item.cartItemId).toSet();
    emit(currentState.copyWith(selectedCartItemIds: allCartItemIds));
  }

  void _onUnselectAllCartItems(UnselectAllCartItemsEvent event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(selectedCartItemIds: {}));
  }

  Future<void> _onGetSelectedItemsPreview(GetSelectedItemsPreviewEvent event, Emitter<CartState> emit) async {
    if (event.selectedCartItemIds.isEmpty) {
      emit(CartError('Vui lòng chọn ít nhất một sản phẩm'));
      return;
    }

    emit(CartLoading());

    final params = GetPreviewOrderParams(cartItemIds: event.selectedCartItemIds);
    final result = await getPreviewOrderUseCase(params);
    
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cartSummary) {
        // Show success message with preview info
        emit(CartItemUpdated(
          'Preview Order: ${cartSummary.totalItem} sản phẩm - ${_formatPrice(cartSummary.totalAmount)}'
        ));
      },
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)}₫';
  }
}
