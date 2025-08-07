import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/deliveries/service_response_entity.dart';

part 'service_response_model.g.dart';

@JsonSerializable()
class ServiceResponseModel extends ServiceResponseEntity {
  const ServiceResponseModel({
    required super.shopId,
    required super.serviceTypeId,
    required super.serviceName,
    required super.totalAmount,
    required super.expectedDeliveryDate,
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceResponseModelToJson(this);

  ServiceResponseEntity toEntity() {
    return ServiceResponseEntity(
      shopId: shopId,
      serviceTypeId: serviceTypeId,
      serviceName: serviceName,
      totalAmount: totalAmount,
      expectedDeliveryDate: expectedDeliveryDate,
    );
  }

  factory ServiceResponseModel.fromEntity(ServiceResponseEntity entity) {
    return ServiceResponseModel(
      shopId: entity.shopId,
      serviceTypeId: entity.serviceTypeId,
      serviceName: entity.serviceName,
      totalAmount: entity.totalAmount,
      expectedDeliveryDate: entity.expectedDeliveryDate,
    );
  }

  ServiceResponseModel copyWith({
    String? shopId,
    int? serviceTypeId,
    String? serviceName,
    double? totalAmount,
    DateTime? expectedDeliveryDate,
  }) {
    return ServiceResponseModel(
      shopId: shopId ?? this.shopId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      serviceName: serviceName ?? this.serviceName,
      totalAmount: totalAmount ?? this.totalAmount,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceResponseModel &&
        other.shopId == shopId &&
        other.serviceTypeId == serviceTypeId &&
        other.serviceName == serviceName &&
        other.totalAmount == totalAmount &&
        other.expectedDeliveryDate == expectedDeliveryDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      shopId,
      serviceTypeId,
      serviceName,
      totalAmount,
      expectedDeliveryDate,
    );
  }

  @override
  String toString() {
    return 'ServiceResponseModel(shopId: $shopId, serviceTypeId: $serviceTypeId, serviceName: $serviceName, totalAmount: $totalAmount, expectedDeliveryDate: $expectedDeliveryDate)';
  }
}