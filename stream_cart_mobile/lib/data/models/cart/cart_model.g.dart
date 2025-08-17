// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceDataModel _$PriceDataModelFromJson(Map<String, dynamic> json) =>
    PriceDataModel(
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceDataModelToJson(PriceDataModel instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'originalPrice': instance.originalPrice,
      'discount': instance.discount,
    };

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      cartItemId: json['cartItemId'] as String,
      productId: json['productId'] as String,
      variantId: json['variantID'] as String?,
      productName: json['productName'] as String,
      priceData:
          PriceDataModel.fromJson(json['priceData'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      primaryImage: json['primaryImage'] as String,
      attributes: json['attributes'] as Map<String, dynamic>?,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      productStatus: json['productStatus'] as bool,
      weight: (json['weight'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'productId': instance.productId,
      'variantID': instance.variantId,
      'productName': instance.productName,
      'priceData': instance.priceData,
      'quantity': instance.quantity,
      'primaryImage': instance.primaryImage,
      'attributes': instance.attributes,
      'stockQuantity': instance.stockQuantity,
      'productStatus': instance.productStatus,
      'weight': instance.weight,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
    };

CartShopModel _$CartShopModelFromJson(Map<String, dynamic> json) =>
    CartShopModel(
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfProduct: (json['numberOfProduct'] as num).toInt(),
      totalPriceInShop: (json['totalPriceInShop'] as num).toDouble(),
    );

Map<String, dynamic> _$CartShopModelToJson(CartShopModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'products': instance.products,
      'numberOfProduct': instance.numberOfProduct,
      'totalPriceInShop': instance.totalPriceInShop,
    };

CreateOrderFromCheckoutModel _$CreateOrderFromCheckoutModelFromJson(
        Map<String, dynamic> json) =>
    CreateOrderFromCheckoutModel(
      selectedCartItemIds: (json['selectedCartItemIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      deliveryAddressId: json['deliveryAddressId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      customerNotes: json['customerNotes'] as String?,
      expectedDeliveryDate: json['expectedDeliveryDate'] as String?,
    );

Map<String, dynamic> _$CreateOrderFromCheckoutModelToJson(
        CreateOrderFromCheckoutModel instance) =>
    <String, dynamic>{
      'selectedCartItemIds': instance.selectedCartItemIds,
      'deliveryAddressId': instance.deliveryAddressId,
      'paymentMethod': instance.paymentMethod,
      'customerNotes': instance.customerNotes,
      'expectedDeliveryDate': instance.expectedDeliveryDate,
    };

CartUpdateResponseModel _$CartUpdateResponseModelFromJson(
        Map<String, dynamic> json) =>
    CartUpdateResponseModel(
      cartItem: json['cartItem'] as String,
      variantId: json['variantId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartUpdateResponseModelToJson(
        CartUpdateResponseModel instance) =>
    <String, dynamic>{
      'cartItem': instance.cartItem,
      'variantId': instance.variantId,
      'quantity': instance.quantity,
    };
