// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceData _$PriceDataFromJson(Map<String, dynamic> json) => PriceData(
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceDataToJson(PriceData instance) => <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'originalPrice': instance.originalPrice,
      'discount': instance.discount,
    };

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      cartItemId: json['cartItemId'] as String?,
      productId: json['productId'] as String,
      variantId: json['variantID'] as String?,
      productName: json['productName'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      primaryImage: json['primaryImage'] as String?,
      priceData: json['priceData'] == null
          ? null
          : PriceData.fromJson(json['priceData'] as Map<String, dynamic>),
      attributes: json['attributes'] as Map<String, dynamic>?,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      productStatus: json['productStatus'] as bool?,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'productId': instance.productId,
      'variantID': instance.variantId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'primaryImage': instance.primaryImage,
      'priceData': instance.priceData,
      'attributes': instance.attributes,
      'stockQuantity': instance.stockQuantity,
      'productStatus': instance.productStatus,
    };

CartShopModel _$CartShopModelFromJson(Map<String, dynamic> json) =>
    CartShopModel(
      shopId: json['shopId'] as String?,
      shopName: json['shopName'] as String?,
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfProduct: (json['numberOfProduct'] as num?)?.toInt(),
      totalPriceInShop: (json['totalPriceInShop'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartShopModelToJson(CartShopModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'products': instance.products,
      'numberOfProduct': instance.numberOfProduct,
      'totalPriceInShop': instance.totalPriceInShop,
    };

CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    CartSummaryModel(
      totalItem: (json['totalItem'] as num?)?.toInt(),
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      listCartItem: (json['listCartItem'] as List<dynamic>?)
          ?.map((e) => CartShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartSummaryModelToJson(CartSummaryModel instance) =>
    <String, dynamic>{
      'totalItem': instance.totalItem,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'listCartItem': instance.listCartItem,
    };

CartUpdateResponseModel _$CartUpdateResponseModelFromJson(
        Map<String, dynamic> json) =>
    CartUpdateResponseModel(
      cartItem: json['cartItem'] as String?,
      variantId: json['variantId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartUpdateResponseModelToJson(
        CartUpdateResponseModel instance) =>
    <String, dynamic>{
      'cartItem': instance.cartItem,
      'variantId': instance.variantId,
      'quantity': instance.quantity,
    };

CartResponseModel _$CartResponseModelFromJson(Map<String, dynamic> json) =>
    CartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CartResponseModelToJson(CartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
