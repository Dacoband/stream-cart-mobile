import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/cart_live/cart_product_live_entity.dart';
import 'price_data_live_model.dart';

part 'cart_product_live_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartProductLiveModel {
  final String cartItemId;
  final String productId;
  final String variantID;
  final String productName;
  @JsonKey(fromJson: PriceDataLiveModel.fromJson, toJson: _priceDataToJson)
  final PriceDataLiveModel priceData;
  final int quantity;
  final String primaryImage;
  final Map<String, String> attributes;
  final int stockQuantity;
  final bool productStatus;
  final double length;
  final double width;
  final double height;
  final double weight;

  const CartProductLiveModel({
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

  factory CartProductLiveModel.fromJson(Map<String, dynamic> json) => _$CartProductLiveModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductLiveModelToJson(this);

  static Map<String, dynamic> _priceDataToJson(PriceDataLiveModel priceData) => priceData.toJson();

  CartProductLiveEntity toEntity() => CartProductLiveEntity(
    cartItemId: cartItemId,
    productId: productId,
    variantID: variantID,
    productName: productName,
    priceData: priceData.toEntity(),
    quantity: quantity,
    primaryImage: primaryImage,
    attributes: attributes,
    stockQuantity: stockQuantity,
    productStatus: productStatus,
    length: length,
    width: width,
    height: height,
    weight: weight,
  );

  factory CartProductLiveModel.fromEntity(CartProductLiveEntity entity) {
    return CartProductLiveModel(
      cartItemId: entity.cartItemId,
      productId: entity.productId,
      variantID: entity.variantID,
      productName: entity.productName,
      priceData: PriceDataLiveModel.fromEntity(entity.priceData),
      quantity: entity.quantity,
      primaryImage: entity.primaryImage,
      attributes: entity.attributes,
      stockQuantity: entity.stockQuantity,
      productStatus: entity.productStatus,
      length: entity.length,
      width: entity.width,
      height: entity.height,
      weight: entity.weight,
    );
  }

  CartProductLiveModel copyWith({
    String? cartItemId,
    String? productId,
    String? variantID,
    String? productName,
    PriceDataLiveModel? priceData,
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
    return CartProductLiveModel(
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
}
