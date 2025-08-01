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
  final List<CartItemEntity> items;
  final double totalAmount;
  final Set<String> selectedCartItemIds; // Track selected items

  const CartLoaded({
    required this.items,
    required this.totalAmount,
    this.selectedCartItemIds = const {},
  });

  @override
  List<Object?> get props => [items, totalAmount, selectedCartItemIds];

  CartLoaded copyWith({
    List<CartItemEntity>? items,
    double? totalAmount,
    Set<String>? selectedCartItemIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedCartItemIds: selectedCartItemIds ?? this.selectedCartItemIds,
    );
  }

  // Helper methods
  bool get hasSelectedItems => selectedCartItemIds.isNotEmpty;
  bool get isAllSelected => items.isNotEmpty && selectedCartItemIds.length == items.length;
  
  List<CartItemEntity> get selectedItems => 
      items.where((item) => selectedCartItemIds.contains(item.cartItemId)).toList();
  
  double get selectedTotalAmount {
    double total = 0;
    for (var item in selectedItems) {
      total += (item.currentPrice * item.quantity);
    }
    return total;
  }
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

class CartPreviewLoaded extends CartState {
  final CartEntity cart;

  const CartPreviewLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}
