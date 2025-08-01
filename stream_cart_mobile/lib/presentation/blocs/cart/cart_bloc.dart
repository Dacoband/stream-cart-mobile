import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_items_usecase.dart';
import '../../../domain/usecases/cart/update_cart_item_usecase.dart';
import '../../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../../domain/usecases/cart/remove_cart_item_usecase.dart';
import '../../../domain/usecases/cart/remove_multiple_cart_items_usecase.dart';
import '../../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_preview_usecase.dart';
import '../../../domain/usecases/order/get_preview_order_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final RemoveMultipleCartItemsUseCase removeMultipleCartItemsUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartPreviewUseCase getCartPreviewUseCase;
  final GetPreviewOrderUseCase getPreviewOrderUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.getCartItemsUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.removeCartItemUseCase,
    required this.removeMultipleCartItemsUseCase,
    required this.clearCartUseCase,
    required this.getCartPreviewUseCase,
    required this.getPreviewOrderUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<RemoveSelectedCartItemsEvent>(_onRemoveSelectedCartItems);
    on<ClearCartEvent>(_onClearCart);
    on<GetCartPreviewEvent>(_onGetCartPreview);
    on<ToggleCartItemSelectionEvent>(_onToggleCartItemSelection);
    on<SelectAllCartItemsEvent>(_onSelectAllCartItems);
    on<UnselectAllCartItemsEvent>(_onUnselectAllCartItems);
    on<GetSelectedItemsPreviewEvent>(_onGetSelectedItemsPreview);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final result = await getCartItemsUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cartItems) {
        double totalAmount = 0;
        for (var item in cartItems) {
          totalAmount += (item.currentPrice * item.quantity);
        }
        emit(CartLoaded(
          items: cartItems, 
          totalAmount: totalAmount,
          selectedCartItemIds: const {},
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
          add(LoadCartEvent());
        } else {
          emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Lỗi không xác định'));
        }
      },
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) {
      emit(CartLoading());
      add(LoadCartEvent());
      return;
    }

    final updatedItems = currentState.items.map((item) {
      if (item.cartItemId == event.cartItemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    double newTotalAmount = 0;
    for (var item in updatedItems) {
      newTotalAmount += (item.currentPrice * item.quantity);
    }

    emit(CartLoaded(items: updatedItems, totalAmount: newTotalAmount));

    final params = UpdateCartItemParams(
      productId: event.productId,
      variantId: event.variantId,
      quantity: event.quantity,
    );
    
    final result = await updateCartItemUseCase(params);
    result.fold(
      (failure) {
        emit(currentState);
        emit(CartError(failure.message));
      },
      (response) {
        if (!response.success) {
          emit(currentState);
          emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Cập nhật không thành công'));
        }
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
    final currentState = state;
    if (currentState is! CartLoaded) {
      print('Current state is not CartLoaded: ${currentState.runtimeType}');
      return;
    }

    final newSelectedItems = Set<String>.from(currentState.selectedCartItemIds);
    if (newSelectedItems.contains(event.cartItemId)) {
      newSelectedItems.remove(event.cartItemId);
    } else {
      newSelectedItems.add(event.cartItemId);
    }
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
        emit(CartItemUpdated(
          'Preview Order: ${cartSummary.totalItem} sản phẩm - ${_formatPrice(cartSummary.totalAmount)}'
        ));
      },
    );
  }

  Future<void> _onRemoveCartItem(RemoveCartItemEvent event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = currentState.items.where((item) => item.cartItemId != event.cartItemId).toList();
      final updatedSelections = Set<String>.from(currentState.selectedCartItemIds);
      updatedSelections.remove(event.cartItemId);
      
      final updatedTotalAmount = updatedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.currentPrice * item.quantity,
      );
      
      emit(CartLoaded(
        items: updatedItems,
        totalAmount: updatedTotalAmount,
        selectedCartItemIds: updatedSelections,
      ));

      final result = await removeCartItemUseCase(event.cartItemId);
      result.fold(
        (failure) {
          add(LoadCartEvent());
          emit(CartError(failure.message));
        },
        (_) {
          add(LoadCartEvent());
          emit(CartItemUpdated('Đã xóa sản phẩm khỏi giỏ hàng'));
        },
      );
    }
  }

  Future<void> _onRemoveSelectedCartItems(RemoveSelectedCartItemsEvent event, Emitter<CartState> emit) async { 
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());

      final result = await removeMultipleCartItemsUseCase(event.cartItemIds);
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) {
          add(LoadCartEvent());
          emit(CartItemUpdated('Đã xóa ${event.cartItemIds.length} sản phẩm khỏi giỏ hàng'));
        },
      );
    }
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)}₫';
  }
}
