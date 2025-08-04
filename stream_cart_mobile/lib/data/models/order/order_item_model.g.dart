// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      variantId: json['variantId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      notes: json['notes'] as String?,
      refundRequestId: json['refundRequestId'] as String?,
      productName: json['productName'] as String,
      productImageUrl: json['productImageUrl'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'variantId': instance.variantId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'discountAmount': instance.discountAmount,
      'totalPrice': instance.totalPrice,
      'notes': instance.notes,
      'refundRequestId': instance.refundRequestId,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
    };
