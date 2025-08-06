// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingItemModel _$ShippingItemModelFromJson(Map<String, dynamic> json) =>
    ShippingItemModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ShippingItemModelToJson(ShippingItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
    };
