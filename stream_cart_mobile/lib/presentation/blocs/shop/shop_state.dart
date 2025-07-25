import 'package:equatable/equatable.dart';
import '../../../domain/entities/shop.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../data/models/shop_model.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final ShopResponse shopResponse;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ShopLoaded({
    required this.shopResponse,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [shopResponse, hasReachedMax, isLoadingMore];

  ShopLoaded copyWith({
    ShopResponse? shopResponse,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ShopLoaded(
      shopResponse: shopResponse ?? this.shopResponse,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ShopDetailLoading extends ShopState {}

class ShopDetailLoaded extends ShopState {
  final Shop shop;
  final List<ProductEntity> products;
  final bool isLoadingProducts;

  const ShopDetailLoaded({
    required this.shop,
    this.products = const [],
    this.isLoadingProducts = false,
  });

  @override
  List<Object> get props => [shop, products, isLoadingProducts];

  ShopDetailLoaded copyWith({
    Shop? shop,
    List<ProductEntity>? products,
    bool? isLoadingProducts,
  }) {
    return ShopDetailLoaded(
      shop: shop ?? this.shop,
      products: products ?? this.products,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object> get props => [message];
}

class ShopSearchLoading extends ShopState {}

class ShopSearchLoaded extends ShopState {
  final ShopResponse searchResults;
  final String searchTerm;

  const ShopSearchLoaded({
    required this.searchResults,
    required this.searchTerm,
  });

  @override
  List<Object> get props => [searchResults, searchTerm];
}
