// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'from_shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FromShopModel _$FromShopModelFromJson(Map<String, dynamic> json) =>
    FromShopModel(
      fromShopId: json['fromShopId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ShippingItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FromShopModelToJson(FromShopModel instance) =>
    <String, dynamic>{
      'fromShopId': instance.fromShopId,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
