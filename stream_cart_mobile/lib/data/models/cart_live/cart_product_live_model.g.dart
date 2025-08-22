// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductLiveModel _$CartProductLiveModelFromJson(
        Map<String, dynamic> json) =>
    CartProductLiveModel(
      cartItemId: json['cartItemId'] as String,
      productId: json['productId'] as String,
      variantID: json['variantID'] as String,
      productName: json['productName'] as String,
      priceData: PriceDataLiveModel.fromJson(
          json['priceData'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      primaryImage: json['primaryImage'] as String,
      attributes: (json['attributes'] as Map?)?.map(
          (k, e) => MapEntry(k.toString(), e.toString()),
        ),
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      productStatus: json['productStatus'] as bool,
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$CartProductLiveModelToJson(
        CartProductLiveModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'productId': instance.productId,
      'variantID': instance.variantID,
      'productName': instance.productName,
      'priceData': CartProductLiveModel._priceDataToJson(instance.priceData),
      'quantity': instance.quantity,
      'primaryImage': instance.primaryImage,
      'attributes': instance.attributes,
      'stockQuantity': instance.stockQuantity,
      'productStatus': instance.productStatus,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'weight': instance.weight,
    };
