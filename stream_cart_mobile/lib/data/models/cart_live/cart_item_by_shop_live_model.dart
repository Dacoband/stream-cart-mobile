import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/cart_live/cart_item_by_shop_live_entity.dart';
import 'cart_product_live_model.dart';

part 'cart_item_by_shop_live_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemByShopLiveModel {
  final String shopId;
  final String shopName;
  @JsonKey(fromJson: _productsFromJson, toJson: _productsToJson)
  final List<CartProductLiveModel> products;

  const CartItemByShopLiveModel({
    required this.shopId,
    required this.shopName,
    required this.products,
  });

  factory CartItemByShopLiveModel.fromJson(Map<String, dynamic> json) => _$CartItemByShopLiveModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemByShopLiveModelToJson(this);

  static List<CartProductLiveModel> _productsFromJson(List<dynamic> json) =>
      json.map((e) => CartProductLiveModel.fromJson(e as Map<String, dynamic>)).toList();
  static List<Map<String, dynamic>> _productsToJson(List<CartProductLiveModel> products) =>
      products.map((e) => e.toJson()).toList();

  CartItemByShopLiveEntity toEntity() => CartItemByShopLiveEntity(
    shopId: shopId,
    shopName: shopName,
    products: products.map((e) => e.toEntity()).toList(),
  );

  factory CartItemByShopLiveModel.fromEntity(CartItemByShopLiveEntity entity) {
    return CartItemByShopLiveModel(
      shopId: entity.shopId,
      shopName: entity.shopName,
      products: entity.products.map((e) => CartProductLiveModel.fromEntity(e)).toList(),
    );
  }

  CartItemByShopLiveModel copyWith({
    String? shopId,
    String? shopName,
    List<CartProductLiveModel>? products,
  }) {
    return CartItemByShopLiveModel(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      products: products ?? this.products,
    );
  }
}
