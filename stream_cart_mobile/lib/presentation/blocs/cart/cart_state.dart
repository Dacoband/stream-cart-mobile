import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart/cart_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartDataEntity cartData;
  final Set<String> selectedCartItemIds;

  const CartLoaded({
    required this.cartData,
    this.selectedCartItemIds = const {},
  });

  @override
  List<Object?> get props => [cartData, selectedCartItemIds];

  CartLoaded copyWith({
    CartDataEntity? cartData,
    Set<String>? selectedCartItemIds,
  }) {
    return CartLoaded(
      cartData: cartData ?? this.cartData,
      selectedCartItemIds: selectedCartItemIds ?? this.selectedCartItemIds,
    );
  }

  //  Helper methods với CartDataEntity
  bool get hasSelectedItems => selectedCartItemIds.isNotEmpty;
  
  List<CartItemEntity> get allItems {
    List<CartItemEntity> items = [];
    for (var shop in cartData.cartItemByShop) {
      items.addAll(shop.products);
    }
    return items;
  }
  
  bool get isAllSelected => allItems.isNotEmpty && selectedCartItemIds.length == allItems.length;
  
  List<CartItemEntity> get selectedItems => 
      allItems.where((item) => selectedCartItemIds.contains(item.cartItemId)).toList();
  
  double get totalAmount {
    double total = 0;
    for (var shop in cartData.cartItemByShop) {
      total += shop.totalPriceInShop;
    }
    return total;
  }
  
  double get selectedTotalAmount {
    double total = 0;
    for (var item in selectedItems) {
      total += (item.priceData.currentPrice * item.quantity);
    }
    return total;
  }

  int get totalItemCount => cartData.totalProduct;
  
  int get selectedItemCount => selectedItems.length;
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemAdded extends CartState {
  final String message;

  const CartItemAdded(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemUpdated extends CartState {
  final String message;

  const CartItemUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemRemoved extends CartState {
  final String message;

  const CartItemRemoved(this.message);

  @override
  List<Object?> get props => [message];
}

class CartCleared extends CartState {
  final String message;

  const CartCleared(this.message);

  @override
  List<Object?> get props => [message];
}

class CartPreviewOrderLoaded extends CartState {
  final PreviewOrderDataEntity previewData;

  const CartPreviewOrderLoaded(this.previewData);

  @override
  List<Object?> get props => [previewData];
}

@Deprecated('Use CartPreviewOrderLoaded instead')
class CartPreviewLoaded extends CartState {
  final CartEntity cart;

  const CartPreviewLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}