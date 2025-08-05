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
    on<NavigateToPreviewOrderEvent>(_onNavigateToPreviewOrder);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      
      final result = await getCartItemsUseCase();
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cartData) {
          emit(CartLoaded(
            cartData: cartData,
            selectedCartItemIds: const {},
          ));
        },
      );
    } catch (e) {
      emit(CartError('Không thể tải giỏ hàng: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
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
            emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Thêm vào giỏ hàng thất bại'));
          }
        },
      );
    } catch (e) {
      emit(CartError('Không thể thêm vào giỏ hàng: $e'));
    }
  }

  Future<void> _onUpdateCartItem(UpdateCartItemEvent event, Emitter<CartState> emit) async {
    try {
      final params = UpdateCartItemParams(
        cartItemId: event.cartItemId,
        quantity: event.quantity,
      );
      
      final result = await updateCartItemUseCase(params);
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (response) {
          if (response.success) {
            emit(CartItemUpdated('Đã cập nhật số lượng'));
            add(LoadCartEvent());
          } else {
            emit(CartError(response.errors.isNotEmpty ? response.errors.first : 'Cập nhật thất bại'));
          }
        },
      );
    } catch (e) {
      emit(CartError('Không thể cập nhật: $e'));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      final params = RemoveFromCartParams(
        productId: event.productId,
        variantId: event.variantId,
      );
      
      final result = await removeFromCartUseCase(params);
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) {
          emit(const CartItemRemoved('Đã xóa sản phẩm khỏi giỏ hàng'));
          add(LoadCartEvent());
        },
      );
    } catch (e) {
      emit(CartError('Không thể xóa sản phẩm: $e'));
    }
  }

  Future<void> _onRemoveCartItem(RemoveCartItemEvent event, Emitter<CartState> emit) async {
    try {
      final result = await removeCartItemUseCase(event.cartItemId);
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) {
          emit(const CartItemRemoved('Đã xóa sản phẩm khỏi giỏ hàng'));
          add(LoadCartEvent());
        },
      );
    } catch (e) {
      emit(CartError('Không thể xóa sản phẩm: $e'));
    }
  }

  Future<void> _onRemoveSelectedCartItems(RemoveSelectedCartItemsEvent event, Emitter<CartState> emit) async {
    try {
      if (event.cartItemIds.isEmpty) {
        emit(CartError('Vui lòng chọn sản phẩm để xóa'));
        return;
      }

      final params = RemoveMultipleCartItemsParams(cartItemIds: event.cartItemIds);
      final result = await removeMultipleCartItemsUseCase(params);
      
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) {
          emit(CartItemRemoved('Đã xóa ${event.cartItemIds.length} sản phẩm khỏi giỏ hàng'));
          add(LoadCartEvent());
        },
      );
    } catch (e) {
      emit(CartError('Không thể xóa sản phẩm: $e'));
    }
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      final result = await clearCartUseCase();
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) {
          emit(const CartCleared('Đã xóa tất cả sản phẩm khỏi giỏ hàng'));
          add(LoadCartEvent());
        },
      );
    } catch (e) {
      emit(CartError('Không thể xóa giỏ hàng: $e'));
    }
  }

  Future<void> _onGetCartPreview(GetCartPreviewEvent event, Emitter<CartState> emit) async {
    try {
      final params = GetCartPreviewParams(cartItemIds: []);
      final result = await getCartPreviewUseCase(params);
      
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (previewData) => emit(CartPreviewOrderLoaded(previewData)),
      );
    } catch (e) {
      emit(CartError('Không thể tải preview: $e'));
    }
  }

  void _onToggleCartItemSelection(ToggleCartItemSelectionEvent event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

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

    final allCartItemIds = currentState.allItems.map((item) => item.cartItemId).toSet();
    emit(currentState.copyWith(selectedCartItemIds: allCartItemIds));
  }

  void _onUnselectAllCartItems(UnselectAllCartItemsEvent event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(selectedCartItemIds: {}));
  }

  Future<void> _onGetSelectedItemsPreview(GetSelectedItemsPreviewEvent event, Emitter<CartState> emit) async {
    try {
      if (event.selectedCartItemIds.isEmpty) {
        emit(CartError('Vui lòng chọn ít nhất một sản phẩm'));
        return;
      }

      emit(CartLoading());

      final params = GetPreviewOrderParams(cartItemIds: event.selectedCartItemIds);
      final result = await getPreviewOrderUseCase(params);
      
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (previewData) => emit(CartPreviewOrderLoaded(previewData)),
      );
    } catch (e) {
      emit(CartError('Không thể tải preview order: $e'));
    }
  }

  void _onNavigateToPreviewOrder(NavigateToPreviewOrderEvent event, Emitter<CartState> emit) {
    add(GetSelectedItemsPreviewEvent(selectedCartItemIds: event.selectedCartItemIds));
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)}₫';
  }
}