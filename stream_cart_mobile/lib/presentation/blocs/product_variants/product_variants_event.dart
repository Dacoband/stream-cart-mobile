import 'package:equatable/equatable.dart';

abstract class ProductVariantsEvent extends Equatable {
  const ProductVariantsEvent();

  @override
  List<Object> get props => [];
}

class GetProductVariantsByProductIdEvent extends ProductVariantsEvent {
  final String productId;

  const GetProductVariantsByProductIdEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class GetProductVariantByIdEvent extends ProductVariantsEvent {
  final String variantId;

  const GetProductVariantByIdEvent(this.variantId);

  @override
  List<Object> get props => [variantId];
}

class CheckVariantAvailabilityEvent extends ProductVariantsEvent {
  final String variantId;
  final int requestedQuantity;

  const CheckVariantAvailabilityEvent({
    required this.variantId,
    required this.requestedQuantity,
  });

  @override
  List<Object> get props => [variantId, requestedQuantity];
}

class SelectVariantEvent extends ProductVariantsEvent {
  final String variantId;

  const SelectVariantEvent(this.variantId);

  @override
  List<Object> get props => [variantId];
}

class ClearSelectedVariantEvent extends ProductVariantsEvent {
  const ClearSelectedVariantEvent();
}