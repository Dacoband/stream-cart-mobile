// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_deliveries_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewDeliveriesResponseModel _$PreviewDeliveriesResponseModelFromJson(
        Map<String, dynamic> json) =>
    PreviewDeliveriesResponseModel(
      serviceResponses: (json['serviceResponses'] as List<dynamic>)
          .map((e) => ServiceResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$PreviewDeliveriesResponseModelToJson(
        PreviewDeliveriesResponseModel instance) =>
    <String, dynamic>{
      'serviceResponses':
          instance.serviceResponses.map((e) => e.toJson()).toList(),
      'totalAmount': instance.totalAmount,
    };
