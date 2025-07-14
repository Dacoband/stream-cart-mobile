import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDetailEvent extends ProductDetailEvent {
  final String productId;

  const LoadProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class AddToCartEvent extends ProductDetailEvent {
  final String productId;
  final String? variantId;
  final int quantity;

  const AddToCartEvent({
    required this.productId,
    this.variantId,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [productId, variantId ?? '', quantity];
}

class SelectVariantEvent extends ProductDetailEvent {
  final String variantId;

  const SelectVariantEvent(this.variantId);

  @override
  List<Object> get props => [variantId];
}

class LoadProductImagesEvent extends ProductDetailEvent {
  final String productId;

  const LoadProductImagesEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
