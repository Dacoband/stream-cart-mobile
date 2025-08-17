// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_deliveries_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewDeliveriesModel _$PreviewDeliveriesModelFromJson(
        Map<String, dynamic> json) =>
    PreviewDeliveriesModel(
      fromShops: (json['fromShops'] as List<dynamic>)
          .map((e) => FromShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      toProvince: json['toProvince'] as String,
      toDistrict: json['toDistrict'] as String,
      toWard: json['toWard'] as String,
    );

Map<String, dynamic> _$PreviewDeliveriesModelToJson(
        PreviewDeliveriesModel instance) =>
    <String, dynamic>{
      'fromShops': instance.fromShops.map((e) => e.toJson()).toList(),
      'toProvince': instance.toProvince,
      'toDistrict': instance.toDistrict,
      'toWard': instance.toWard,
    };
