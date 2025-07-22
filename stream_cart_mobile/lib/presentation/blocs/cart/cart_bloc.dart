import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/get_cart_items_usecase.dart';
import '../../../domain/usecases/update_cart_item_usecase.dart';
import '../../../domain/usecases/remove_from_cart_usecase.dart';
import '../../../domain/usecases/clear_cart_usecase.dart';
import '../../../domain/usecases/get_cart_preview_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartPreviewUseCase getCartPreviewUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.getCartItemsUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.getCartPreviewUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<GetCartPreviewEvent>(_onGetCartPreview);
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
        emit(CartLoaded(items: cartItems, totalAmount: totalAmount));
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
    // Don't show loading for update operations to maintain UI responsiveness
    
    final params = UpdateCartItemParams(
      productId: event.productId,
      variantId: event.variantId,
      quantity: event.quantity,
    );
    
    final result = await updateCartItemUseCase(params);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (response) {
        if (response.success) {
          // Update successful, reload cart to get fresh data
          emit(CartItemUpdated(response.message));
          add(LoadCartEvent());
        } else {
          emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Lỗi không xác định'));
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
}
