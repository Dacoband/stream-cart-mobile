import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/cart/cart_entity.dart';

part 'cart_model.g.dart';

// Price Data Model - match với PriceDataEntity
@JsonSerializable()
class PriceDataModel {
  @JsonKey(name: 'currentPrice')
  final double currentPrice;
  
  @JsonKey(name: 'originalPrice')
  final double originalPrice;
  
  @JsonKey(name: 'discount')
  final double discount;

  const PriceDataModel({
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
  });

  factory PriceDataModel.fromJson(Map<String, dynamic> json) => _$PriceDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$PriceDataModelToJson(this);

  PriceDataEntity toEntity() {
    return PriceDataEntity(
      currentPrice: currentPrice,
      originalPrice: originalPrice,
      discount: discount,
    );
  }

  factory PriceDataModel.fromEntity(PriceDataEntity entity) {
    return PriceDataModel(
      currentPrice: entity.currentPrice,
      originalPrice: entity.originalPrice,
      discount: entity.discount,
    );
  }
}

// CartItemModel - Core cart item structure
@JsonSerializable()
class CartItemModel {
  @JsonKey(name: 'cartItemId')
  final String cartItemId;
  
  @JsonKey(name: 'productId')
  final String productId;
  
  @JsonKey(name: 'variantID')
  final String? variantId;
  
  @JsonKey(name: 'productName')
  final String productName;
  
  @JsonKey(name: 'priceData')
  final PriceDataModel priceData;
  
  @JsonKey(name: 'quantity')
  final int quantity;
  
  @JsonKey(name: 'primaryImage')
  final String primaryImage;
  
  @JsonKey(name: 'attributes')
  final Map<String, dynamic>? attributes;
  
  @JsonKey(name: 'stockQuantity')
  final int stockQuantity;
  
  @JsonKey(name: 'productStatus')
  final bool productStatus;

  @JsonKey(name: 'weight')
  final double weight;
  
  @JsonKey(name: 'length')
  final double length;
  
  @JsonKey(name: 'width')
  final double width;
  
  @JsonKey(name: 'height')
  final double height;

  const CartItemModel({
    required this.cartItemId,
    required this.productId,
    this.variantId,
    required this.productName,
    required this.priceData,
    required this.quantity,
    required this.primaryImage,
    this.attributes,
    required this.stockQuantity,
    required this.productStatus,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cartItemId'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantID'],
      productName: json['productName'] ?? '',
      priceData: PriceDataModel.fromJson(json['priceData'] ?? {}),
      quantity: json['quantity'] ?? 0,
      primaryImage: json['primaryImage'] ?? '',
      attributes: json['attributes'],
      stockQuantity: json['stockQuantity'] ?? 0,
      productStatus: json['productStatus'] ?? false,
      weight: (json['weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toEntity() {
    return CartItemEntity(
      cartItemId: cartItemId,
      productId: productId,
      variantId: variantId,
      productName: productName,
      priceData: priceData.toEntity(),
      quantity: quantity,
      primaryImage: primaryImage,
      attributes: attributes,
      stockQuantity: stockQuantity,
      productStatus: productStatus,
      weight: weight,
      length: length,
      width: width,
      height: height,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      cartItemId: entity.cartItemId,
      productId: entity.productId,
      variantId: entity.variantId,
      productName: entity.productName,
      priceData: PriceDataModel.fromEntity(entity.priceData),
      quantity: entity.quantity,
      primaryImage: entity.primaryImage,
      attributes: entity.attributes,
      stockQuantity: entity.stockQuantity,
      productStatus: entity.productStatus,
      weight: entity.weight,
      length: entity.length,
      width: entity.width,
      height: entity.height,
    );
  }
}

// CartShopModel - Shop with products
@JsonSerializable()
class CartShopModel {
  @JsonKey(name: 'shopId')
  final String shopId;
  
  @JsonKey(name: 'shopName')
  final String shopName;
  
  @JsonKey(name: 'products')
  final List<CartItemModel> products;
  
  @JsonKey(name: 'numberOfProduct')
  final int numberOfProduct;
  
  @JsonKey(name: 'totalPriceInShop')
  final double totalPriceInShop;

  const CartShopModel({
    required this.shopId,
    required this.shopName,
    required this.products,
    required this.numberOfProduct,
    required this.totalPriceInShop,
  });

  factory CartShopModel.fromJson(Map<String, dynamic> json) => _$CartShopModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartShopModelToJson(this);

  CartShopEntity toEntity() {
    return CartShopEntity(
      shopId: shopId,
      shopName: shopName,
      products: products.map((product) => product.toEntity()).toList(),
      numberOfProduct: numberOfProduct,
      totalPriceInShop: totalPriceInShop,
    );
  }

  factory CartShopModel.fromEntity(CartShopEntity entity) {
    return CartShopModel(
      shopId: entity.shopId,
      shopName: entity.shopName,
      products: entity.products.map((item) => CartItemModel.fromEntity(item)).toList(),
      numberOfProduct: entity.numberOfProduct,
      totalPriceInShop: entity.totalPriceInShop,
    );
  }
}

// CreateOrderFromCheckoutModel - Request model cho checkout
@JsonSerializable()
class CreateOrderFromCheckoutModel {
  @JsonKey(name: 'selectedCartItemIds')
  final List<String> selectedCartItemIds;
  
  @JsonKey(name: 'deliveryAddressId')
  final String deliveryAddressId;
  
  @JsonKey(name: 'paymentMethod')
  final String paymentMethod;
  
  @JsonKey(name: 'customerNotes')
  final String? customerNotes;
  
  @JsonKey(name: 'expectedDeliveryDate')
  final String? expectedDeliveryDate;

  const CreateOrderFromCheckoutModel({
    required this.selectedCartItemIds,
    required this.deliveryAddressId,
    required this.paymentMethod,
    this.customerNotes,
    this.expectedDeliveryDate,
  });

  factory CreateOrderFromCheckoutModel.fromJson(Map<String, dynamic> json) => _$CreateOrderFromCheckoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderFromCheckoutModelToJson(this);

  CreateOrderFromCheckoutEntity toEntity() {
    return CreateOrderFromCheckoutEntity(
      selectedCartItemIds: selectedCartItemIds,
      deliveryAddressId: deliveryAddressId,
      paymentMethod: paymentMethod,
      customerNotes: customerNotes,
      expectedDeliveryDate: expectedDeliveryDate != null 
          ? DateTime.parse(expectedDeliveryDate!)
          : null,
    );
  }

  factory CreateOrderFromCheckoutModel.fromEntity(CreateOrderFromCheckoutEntity entity) {
    return CreateOrderFromCheckoutModel(
      selectedCartItemIds: entity.selectedCartItemIds,
      deliveryAddressId: entity.deliveryAddressId,
      paymentMethod: entity.paymentMethod,
      customerNotes: entity.customerNotes,
      expectedDeliveryDate: entity.expectedDeliveryDate?.toIso8601String(),
    );
  }
}

// Cart Update Response Model (cho operations)
@JsonSerializable()
class CartUpdateResponseModel {
  @JsonKey(name: 'cartItem')
  final String cartItem;
  
  @JsonKey(name: 'variantId')
  final String? variantId;
  
  @JsonKey(name: 'quantity')
  final int quantity;

  const CartUpdateResponseModel({
    required this.cartItem,
    this.variantId,
    required this.quantity,
  });

  factory CartUpdateResponseModel.fromJson(Map<String, dynamic> json) => _$CartUpdateResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartUpdateResponseModelToJson(this);
}