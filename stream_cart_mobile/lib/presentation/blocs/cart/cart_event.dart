import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final String variantId;
  final int quantity;

  const AddToCartEvent({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class UpdateCartItemEvent extends CartEvent {
  final String cartItemId;
  final String productId;
  final String? variantId;
  final int quantity;

  const UpdateCartItemEvent({
    required this.cartItemId,
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, productId, variantId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  final String? variantId;

  const RemoveFromCartEvent({
    required this.productId,
    required this.variantId,
  });

  @override
  List<Object?> get props => [productId, variantId];
}

class ClearCartEvent extends CartEvent {}

class GetCartPreviewEvent extends CartEvent {}

class ToggleCartItemSelectionEvent extends CartEvent {
  final String cartItemId;

  const ToggleCartItemSelectionEvent({
    required this.cartItemId,
  });

  @override
  List<Object?> get props => [cartItemId];
}

class SelectAllCartItemsEvent extends CartEvent {}

class UnselectAllCartItemsEvent extends CartEvent {}

class GetSelectedItemsPreviewEvent extends CartEvent {
  final List<String> selectedCartItemIds;

  const GetSelectedItemsPreviewEvent({
    required this.selectedCartItemIds,
  });

  @override
  List<Object?> get props => [selectedCartItemIds];
}
