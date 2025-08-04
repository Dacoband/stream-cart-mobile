// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCartResponseData _$GetCartResponseDataFromJson(Map<String, dynamic> json) =>
    GetCartResponseData(
      cartId: json['cartId'] as String,
      customerId: json['customerId'] as String,
      totalProduct: (json['totalProduct'] as num).toInt(),
      cartItemByShop: (json['cartItemByShop'] as List<dynamic>)
          .map((e) => CartShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCartResponseDataToJson(
        GetCartResponseData instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'customerId': instance.customerId,
      'totalProduct': instance.totalProduct,
      'cartItemByShop': instance.cartItemByShop,
    };

GetCartResponseModel _$GetCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : GetCartResponseData.fromJson(json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GetCartResponseModelToJson(
        GetCartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };
