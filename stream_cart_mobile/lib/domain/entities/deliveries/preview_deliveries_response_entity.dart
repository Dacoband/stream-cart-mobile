import 'package:equatable/equatable.dart';

import 'service_response_entity.dart';

class PreviewDeliveriesResponseEntity extends Equatable {
  final List<ServiceResponseEntity> serviceResponses;
  final double totalAmount;

  const PreviewDeliveriesResponseEntity({
    required this.serviceResponses,
    required this.totalAmount,
  });

  PreviewDeliveriesResponseEntity copyWith({
    List<ServiceResponseEntity>? serviceResponses,
    double? totalAmount,
  }) {
    return PreviewDeliveriesResponseEntity(
      serviceResponses: serviceResponses ?? this.serviceResponses,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [serviceResponses, totalAmount];

  @override
  String toString() {
    return 'PreviewDeliveriesResponseEntity(serviceResponses: $serviceResponses, totalAmount: $totalAmount)';
  }
}