// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_order_item_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOrderItemRequestModel _$AddOrderItemRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddOrderItemRequestModel(
      productId: json['productId'] as String,
      variantId: json['variantId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$AddOrderItemRequestModelToJson(
        AddOrderItemRequestModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'variantId': instance.variantId,
      'quantity': instance.quantity,
    };
