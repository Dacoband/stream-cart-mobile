import 'package:equatable/equatable.dart';
import 'cart_product_live_entity.dart';

class CartItemByShopLiveEntity extends Equatable {
  final String shopId;
  final String shopName;
  final List<CartProductLiveEntity> products;

  const CartItemByShopLiveEntity({
    required this.shopId,
    required this.shopName,
    required this.products,
  });

  CartItemByShopLiveEntity copyWith({
    String? shopId,
    String? shopName,
    List<CartProductLiveEntity>? products,
  }) {
    return CartItemByShopLiveEntity(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [shopId, shopName, products];

  @override
  String toString() => 'CartItemByShopLiveEntity(shopId: $shopId, shopName: $shopName, products: $products)';
}
