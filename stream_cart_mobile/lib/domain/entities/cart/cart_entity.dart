import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String cartItemId;
  final String productId;
  final String? variantId;
  final String productName;
  final int quantity;
  final String primaryImage;
  final double currentPrice;
  final double originalPrice;
  final Map<String, dynamic>? attributes;
  final int stockQuantity;
  final bool productStatus;

  const CartItemEntity({
    required this.cartItemId,
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.quantity,
    required this.primaryImage,
    required this.currentPrice,
    required this.originalPrice,
    this.attributes,
    required this.stockQuantity,
    required this.productStatus,
  });

  CartItemEntity copyWith({
    String? cartItemId,
    String? productId,
    String? variantId,
    String? productName,
    int? quantity,
    String? primaryImage,
    double? currentPrice,
    double? originalPrice,
    Map<String, dynamic>? attributes,
    int? stockQuantity,
    bool? productStatus,
  }) {
    return CartItemEntity(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      primaryImage: primaryImage ?? this.primaryImage,
      currentPrice: currentPrice ?? this.currentPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      attributes: attributes ?? this.attributes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      productStatus: productStatus ?? this.productStatus,
    );
  }

  @override
  List<Object?> get props => [
    cartItemId, 
    productId, 
    variantId, 
    productName, 
    quantity, 
    primaryImage, 
    currentPrice, 
    originalPrice, 
    attributes, 
    stockQuantity, 
    productStatus
  ];
}

class CartShopEntity extends Equatable {
  final String shopId;
  final String shopName;
  final List<CartItemEntity> products;
  final int numberOfProduct;
  final double totalPriceInShop;

  const CartShopEntity({
    required this.shopId,
    required this.shopName,
    required this.products,
    required this.numberOfProduct,
    required this.totalPriceInShop,
  });

  @override
  List<Object?> get props => [shopId, shopName, products, numberOfProduct, totalPriceInShop];
}

class CartSummaryEntity extends Equatable {
  final int totalItem;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final List<CartShopEntity> listCartItem;

  const CartSummaryEntity({
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.listCartItem,
  });

  @override
  List<Object?> get props => [totalItem, subTotal, discount, totalAmount, listCartItem];
}

class CartResponseEntity extends Equatable {
  final bool success;
  final String message;
  final dynamic data; // Can be different types based on operation
  final List<String> errors;

  const CartResponseEntity({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  @override
  List<Object?> get props => [success, message, data, errors];
}

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, items, totalAmount, createdAt, updatedAt];
}
