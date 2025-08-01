import 'package:equatable/equatable.dart';
import '../../../domain/entities/products/product_variants_entity.dart';
import '../../../domain/entities/products/product_variants_entity.dart';

abstract class ProductVariantsState extends Equatable {
  const ProductVariantsState();

  @override
  List<Object?> get props => [];
}

class ProductVariantsInitial extends ProductVariantsState {}

class ProductVariantsLoading extends ProductVariantsState {}

class ProductVariantsLoaded extends ProductVariantsState {
  final List<ProductVariantEntity> variants;
  final ProductVariantEntity? selectedVariant;
  final ProductVariantEntity? cheapestVariant;

  const ProductVariantsLoaded({
    required this.variants,
    this.selectedVariant,
    this.cheapestVariant,
  });

  @override
  List<Object?> get props => [variants, selectedVariant, cheapestVariant];

  ProductVariantsLoaded copyWith({
    List<ProductVariantEntity>? variants,
    ProductVariantEntity? selectedVariant,
    ProductVariantEntity? cheapestVariant,
    bool clearSelectedVariant = false,
  }) {
    return ProductVariantsLoaded(
      variants: variants ?? this.variants,
      selectedVariant: clearSelectedVariant ? null : (selectedVariant ?? this.selectedVariant),
      cheapestVariant: cheapestVariant ?? this.cheapestVariant,
    );
  }
}

class ProductVariantSelected extends ProductVariantsState {
  final ProductVariantEntity variant;

  const ProductVariantSelected(this.variant);

  @override
  List<Object> get props => [variant];
}

class VariantAvailabilityChecked extends ProductVariantsState {
  final bool isAvailable;
  final String variantId;
  final int requestedQuantity;

  const VariantAvailabilityChecked({
    required this.isAvailable,
    required this.variantId,
    required this.requestedQuantity,
  });

  @override
  List<Object> get props => [isAvailable, variantId, requestedQuantity];
}

class ProductVariantsError extends ProductVariantsState {
  final String message;

  const ProductVariantsError(this.message);

  @override
  List<Object> get props => [message];
}