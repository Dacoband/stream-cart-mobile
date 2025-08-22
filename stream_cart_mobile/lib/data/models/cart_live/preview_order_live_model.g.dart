// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_order_live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewOrderLiveModel _$PreviewOrderLiveModelFromJson(
        Map<String, dynamic> json) =>
    PreviewOrderLiveModel(
      livestreamId: json['livestreamId'] as String,
      totalItem: (json['totalItem'] as num).toInt(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      listCartItem: PreviewOrderLiveModel._listCartItemFromJson(
          json['listCartItem'] as List),
    );

Map<String, dynamic> _$PreviewOrderLiveModelToJson(
        PreviewOrderLiveModel instance) =>
    <String, dynamic>{
      'livestreamId': instance.livestreamId,
      'totalItem': instance.totalItem,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'listCartItem':
          PreviewOrderLiveModel._listCartItemToJson(instance.listCartItem),
    };
