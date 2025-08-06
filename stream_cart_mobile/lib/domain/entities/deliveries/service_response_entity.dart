import 'package:equatable/equatable.dart';

class ServiceResponseEntity extends Equatable {
  final String shopId;
  final int serviceTypeId;
  final String serviceName;
  final double totalAmount;
  final DateTime expectedDeliveryDate;

  const ServiceResponseEntity({
    required this.shopId,
    required this.serviceTypeId,
    required this.serviceName,
    required this.totalAmount,
    required this.expectedDeliveryDate,
  });

  ServiceResponseEntity copyWith({
    String? shopId,
    int? serviceTypeId,
    String? serviceName,
    double? totalAmount,
    DateTime? expectedDeliveryDate,
  }) {
    return ServiceResponseEntity(
      shopId: shopId ?? this.shopId,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      serviceName: serviceName ?? this.serviceName,
      totalAmount: totalAmount ?? this.totalAmount,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
    );
  }

  @override
  List<Object?> get props => [
        shopId,
        serviceTypeId,
        serviceName,
        totalAmount,
        expectedDeliveryDate,
      ];

  @override
  String toString() {
    return 'ServiceResponseEntity(shopId: $shopId, serviceTypeId: $serviceTypeId, serviceName: $serviceName, totalAmount: $totalAmount, expectedDeliveryDate: $expectedDeliveryDate)';
  }
}