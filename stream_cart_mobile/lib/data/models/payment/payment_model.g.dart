// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneratePaymentQrRequestModel _$GeneratePaymentQrRequestModelFromJson(
        Map<String, dynamic> json) =>
    GeneratePaymentQrRequestModel(
      orderIds:
          (json['orderIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GeneratePaymentQrRequestModelToJson(
        GeneratePaymentQrRequestModel instance) =>
    <String, dynamic>{
      'orderIds': instance.orderIds,
    };

PaymentQrModel _$PaymentQrModelFromJson(Map<String, dynamic> json) =>
    PaymentQrModel(
      qrImageUrl: json['qrImageUrl'] as String,
    );

Map<String, dynamic> _$PaymentQrModelToJson(PaymentQrModel instance) =>
    <String, dynamic>{
      'qrImageUrl': instance.qrImageUrl,
    };
