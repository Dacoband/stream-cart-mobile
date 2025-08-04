// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequestModel _$CreateOrderRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateOrderRequestModel(
      paymentMethod: json['paymentMethod'] as String,
      addressId: json['addressId'] as String,
      livestreamId: json['livestreamId'] as String?,
      createdFromCommentId: json['createdFromCommentId'] as String?,
      ordersByShop: (json['ordersByShop'] as List<dynamic>)
          .map((e) => OrderByShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateOrderRequestModelToJson(
        CreateOrderRequestModel instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod,
      'addressId': instance.addressId,
      'livestreamId': instance.livestreamId,
      'createdFromCommentId': instance.createdFromCommentId,
      'ordersByShop': instance.ordersByShop,
    };

OrderByShopModel _$OrderByShopModelFromJson(Map<String, dynamic> json) =>
    OrderByShopModel(
      shopId: json['shopId'] as String,
      shippingProviderId: json['shippingProviderId'] as String?,
      shippingFee: (json['shippingFee'] as num).toDouble(),
      expectedDeliveryDay: json['expectedDeliveryDay'] as String?,
      voucherCode: json['voucherCode'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => CreateOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerNotes: json['customerNotes'] as String?,
    );

Map<String, dynamic> _$OrderByShopModelToJson(OrderByShopModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'shippingProviderId': instance.shippingProviderId,
      'shippingFee': instance.shippingFee,
      'expectedDeliveryDay': instance.expectedDeliveryDay,
      'voucherCode': instance.voucherCode,
      'customerNotes': instance.customerNotes,
      'items': instance.items,
    };

CreateOrderItemModel _$CreateOrderItemModelFromJson(
        Map<String, dynamic> json) =>
    CreateOrderItemModel(
      productId: json['productId'] as String,
      variantId: json['variantId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CreateOrderItemModelToJson(
        CreateOrderItemModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'variantId': instance.variantId,
      'quantity': instance.quantity,
    };
