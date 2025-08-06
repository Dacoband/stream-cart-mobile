// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceResponseModel _$ServiceResponseModelFromJson(
        Map<String, dynamic> json) =>
    ServiceResponseModel(
      shopId: json['shopId'] as String,
      serviceTypeId: (json['serviceTypeId'] as num).toInt(),
      serviceName: json['serviceName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      expectedDeliveryDate:
          DateTime.parse(json['expectedDeliveryDate'] as String),
    );

Map<String, dynamic> _$ServiceResponseModelToJson(
        ServiceResponseModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'serviceTypeId': instance.serviceTypeId,
      'serviceName': instance.serviceName,
      'totalAmount': instance.totalAmount,
      'expectedDeliveryDate': instance.expectedDeliveryDate.toIso8601String(),
    };
