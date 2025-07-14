import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_detail_entity.dart';
import '../../../domain/entities/product_image_entity.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailEntity productDetail;
  final String? selectedVariantId;
  final List<ProductImageEntity>? productImages;

  const ProductDetailLoaded({
    required this.productDetail,
    this.selectedVariantId,
    this.productImages,
  });

  @override
  List<Object> get props => [
    productDetail, 
    selectedVariantId ?? '', 
    productImages ?? []
  ];

  ProductDetailLoaded copyWith({
    ProductDetailEntity? productDetail,
    String? selectedVariantId,
    List<ProductImageEntity>? productImages,
  }) {
    return ProductDetailLoaded(
      productDetail: productDetail ?? this.productDetail,
      selectedVariantId: selectedVariantId ?? this.selectedVariantId,
      productImages: productImages ?? this.productImages,
    );
  }
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCartLoading extends ProductDetailState {}

class AddToCartSuccess extends ProductDetailState {
  final String message;

  const AddToCartSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCartError extends ProductDetailState {
  final String message;

  const AddToCartError(this.message);

  @override
  List<Object> get props => [message];
}
