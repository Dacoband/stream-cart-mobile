// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCartResponseDataModel _$GetCartResponseDataModelFromJson(
        Map<String, dynamic> json) =>
    GetCartResponseDataModel(
      cartId: json['cartId'] as String,
      customerId: json['customerId'] as String,
      totalProduct: (json['totalProduct'] as num).toInt(),
      cartItemByShop: (json['cartItemByShop'] as List<dynamic>)
          .map((e) => CartShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCartResponseDataModelToJson(
        GetCartResponseDataModel instance) =>
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
          : GetCartResponseDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
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

PreviewOrderDataModel _$PreviewOrderDataModelFromJson(
        Map<String, dynamic> json) =>
    PreviewOrderDataModel(
      totalItem: (json['totalItem'] as num).toInt(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      listCartItem: (json['listCartItem'] as List<dynamic>)
          .map((e) => CartShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreviewOrderDataModelToJson(
        PreviewOrderDataModel instance) =>
    <String, dynamic>{
      'totalItem': instance.totalItem,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'listCartItem': instance.listCartItem,
    };

PreviewOrderResponseModel _$PreviewOrderResponseModelFromJson(
        Map<String, dynamic> json) =>
    PreviewOrderResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : PreviewOrderDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PreviewOrderResponseModelToJson(
        PreviewOrderResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

AddToCartResponseModel _$AddToCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddToCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddToCartResponseModelToJson(
        AddToCartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

UpdateCartResponseModel _$UpdateCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    UpdateCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : CartUpdateResponseModel.fromJson(
              json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UpdateCartResponseModelToJson(
        UpdateCartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

DeleteCartResponseModel _$DeleteCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeleteCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeleteCartResponseModelToJson(
        DeleteCartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    CartSummaryModel(
      totalItem: (json['totalItem'] as num).toInt(),
      subTotal: (json['subTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      listCartItem: (json['listCartItem'] as List<dynamic>)
          .map((e) => CartShopModel.fromJson(e as Map<String, dynamic>))
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
