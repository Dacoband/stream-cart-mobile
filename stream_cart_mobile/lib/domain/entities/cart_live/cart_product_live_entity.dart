import 'package:equatable/equatable.dart';
import 'price_data_live_entity.dart';

class CartProductLiveEntity extends Equatable {
  final String cartItemId;
  final String productId;
  final String variantID;
  final String productName;
  final PriceDataLiveEntity priceData;
  final int quantity;
  final String primaryImage;
  final Map<String, String> attributes;
  final int stockQuantity;
  final bool productStatus;
  final double length;
  final double width;
  final double height;
  final double weight;

  const CartProductLiveEntity({
    required this.cartItemId,
    required this.productId,
    required this.variantID,
    required this.productName,
    required this.priceData,
    required this.quantity,
    required this.primaryImage,
    required this.attributes,
    required this.stockQuantity,
    required this.productStatus,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  CartProductLiveEntity copyWith({
    String? cartItemId,
    String? productId,
    String? variantID,
    String? productName,
    PriceDataLiveEntity? priceData,
    int? quantity,
    String? primaryImage,
    Map<String, String>? attributes,
    int? stockQuantity,
    bool? productStatus,
    double? length,
    double? width,
    double? height,
    double? weight,
  }) {
    return CartProductLiveEntity(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      variantID: variantID ?? this.variantID,
      productName: productName ?? this.productName,
      priceData: priceData ?? this.priceData,
      quantity: quantity ?? this.quantity,
      primaryImage: primaryImage ?? this.primaryImage,
      attributes: attributes ?? this.attributes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      productStatus: productStatus ?? this.productStatus,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  List<Object?> get props => [
    cartItemId,
    productId,
    variantID,
    productName,
    priceData,
    quantity,
    primaryImage,
    attributes,
    stockQuantity,
    productStatus,
    length,
    width,
    height,
    weight,
  ];

  @override
  String toString() => 'CartProductLiveEntity(cartItemId: $cartItemId, productId: $productId, variantID: $variantID, productName: $productName, priceData: $priceData, quantity: $quantity, primaryImage: $primaryImage, attributes: $attributes, stockQuantity: $stockQuantity, productStatus: $productStatus, length: $length, width: $width, height: $height, weight: $weight)';
}
