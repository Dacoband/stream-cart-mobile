import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_entity.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class PriceData {
  @JsonKey(name: 'currentPrice')
  final double currentPrice;
  
  @JsonKey(name: 'originalPrice')
  final double originalPrice;
  
  @JsonKey(name: 'discount')
  final double discount;

  const PriceData({
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) => _$PriceDataFromJson(json);
  Map<String, dynamic> toJson() => _$PriceDataToJson(this);
}

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: 'cartItemId')
  final String? cartItemId;
  
  @JsonKey(name: 'productId')
  final String productId;
  
  @JsonKey(name: 'variantID')  // Note: API uses 'variantID' not 'variantId'
  final String? variantId;
  
  @JsonKey(name: 'productName')
  final String? productName;
  
  @JsonKey(name: 'quantity')
  final int quantity;
  
  @JsonKey(name: 'primaryImage')
  final String? primaryImage;
  
  @JsonKey(name: 'priceData')
  final PriceData? priceData;
  
  @JsonKey(name: 'attributes')
  final Map<String, dynamic>? attributes;
  
  @JsonKey(name: 'stockQuantity')
  final int? stockQuantity;
  
  @JsonKey(name: 'productStatus')
  final bool? productStatus;

  const CartItemModel({
    this.cartItemId,
    required this.productId,
    this.variantId,
    this.productName,
    required this.quantity,
    this.primaryImage,
    this.priceData,
    this.attributes,
    this.stockQuantity,
    this.productStatus,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  
  Map<String, dynamic> toJson() {
    final json = _$CartItemModelToJson(this);
    // Xử lý variantId null cho API
    if (variantId == null || variantId!.isEmpty) {
      json['variantId'] = '';
    }
    return json;
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      cartItemId: cartItemId ?? '',
      productId: productId,
      variantId: variantId,  // Keep null as null instead of converting to empty string
      productName: productName ?? '',
      quantity: quantity,
      primaryImage: primaryImage ?? '',
      currentPrice: priceData?.currentPrice ?? 0.0,
      originalPrice: priceData?.originalPrice ?? 0.0,
      attributes: attributes,
      stockQuantity: stockQuantity ?? 0,
      productStatus: productStatus ?? true,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      cartItemId: entity.cartItemId.isEmpty ? null : entity.cartItemId,
      productId: entity.productId,
      variantId: entity.variantId,  // Keep null as null
      productName: entity.productName.isEmpty ? null : entity.productName,
      quantity: entity.quantity,
      primaryImage: entity.primaryImage.isEmpty ? null : entity.primaryImage,
      priceData: PriceData(
        currentPrice: entity.currentPrice,
        originalPrice: entity.originalPrice,
        discount: 1.0, // Default discount
      ),
      attributes: entity.attributes,
      stockQuantity: entity.stockQuantity,
      productStatus: entity.productStatus,
    );
  }
}

@JsonSerializable()
class CartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final CartItemModel? data;
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const CartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) => _$CartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);

  CartResponseEntity toEntity() {
    return CartResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
      errors: errors,
    );
  }
}

@JsonSerializable()
class CartModel {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'items')
  final List<CartItemModel> items;
  
  @JsonKey(name: 'totalAmount')
  final double totalAmount;
  
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  const CartModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      items: entity.items.map((item) => CartItemModel.fromEntity(item)).toList(),
      totalAmount: entity.totalAmount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
