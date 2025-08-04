// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      orderCode: json['orderCode'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      orderStatus: (json['orderStatus'] as num).toInt(),
      paymentStatus: (json['paymentStatus'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      customerNotes: json['customerNotes'] as String?,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryDate'] as String),
      actualDeliveryDate: json['actualDeliveryDate'] == null
          ? null
          : DateTime.parse(json['actualDeliveryDate'] as String),
      trackingCode: json['trackingCode'] as String?,
      shippingAddress: OrderModel._shippingAddressFromJson(
          json['shippingAddress'] as Map<String, dynamic>),
      accountId: json['accountId'] as String,
      shopId: json['shopId'] as String,
      shippingProviderId: json['shippingProviderId'] as String?,
      livestreamId: json['livestreamId'] as String?,
      voucherCode: json['voucherCode'] as String?,
      items: OrderModel._itemsFromJson(json['items'] as List),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderCode': instance.orderCode,
      'orderDate': instance.orderDate.toIso8601String(),
      'orderStatus': instance.orderStatus,
      'paymentStatus': instance.paymentStatus,
      'totalPrice': instance.totalPrice,
      'shippingFee': instance.shippingFee,
      'discountAmount': instance.discountAmount,
      'finalAmount': instance.finalAmount,
      'customerNotes': instance.customerNotes,
      'estimatedDeliveryDate':
          instance.estimatedDeliveryDate?.toIso8601String(),
      'actualDeliveryDate': instance.actualDeliveryDate?.toIso8601String(),
      'trackingCode': instance.trackingCode,
      'accountId': instance.accountId,
      'shopId': instance.shopId,
      'shippingProviderId': instance.shippingProviderId,
      'livestreamId': instance.livestreamId,
      'voucherCode': instance.voucherCode,
      'shippingAddress':
          OrderModel._shippingAddressToJson(instance.shippingAddress),
      'items': OrderModel._itemsToJson(instance.items),
    };
