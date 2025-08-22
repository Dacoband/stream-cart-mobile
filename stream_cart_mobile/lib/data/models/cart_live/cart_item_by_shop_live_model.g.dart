// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_by_shop_live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemByShopLiveModel _$CartItemByShopLiveModelFromJson(
        Map<String, dynamic> json) =>
    CartItemByShopLiveModel(
      shopId: json['shopId'] as String,
      shopName: json['shopName'] as String,
      products:
          CartItemByShopLiveModel._productsFromJson(json['products'] as List),
    );

Map<String, dynamic> _$CartItemByShopLiveModelToJson(
        CartItemByShopLiveModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shopName': instance.shopName,
      'products': CartItemByShopLiveModel._productsToJson(instance.products),
    };
