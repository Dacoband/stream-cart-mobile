// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_data_live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceDataLiveModel _$PriceDataLiveModelFromJson(Map<String, dynamic> json) =>
    PriceDataLiveModel(
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceDataLiveModelToJson(PriceDataLiveModel instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'originalPrice': instance.originalPrice,
      'discount': instance.discount,
    };
