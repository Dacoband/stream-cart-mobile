import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import '../../../domain/entities/deliveries/preview_deliveries_response_entity.dart';
import 'service_response_model.dart';

part 'preview_deliveries_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviewDeliveriesResponseModel {
  final List<ServiceResponseModel> serviceResponses;
  final double totalAmount;

  const PreviewDeliveriesResponseModel({
    required this.serviceResponses,
    required this.totalAmount,
  });

  factory PreviewDeliveriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PreviewDeliveriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PreviewDeliveriesResponseModelToJson(this);

  PreviewDeliveriesResponseEntity toEntity() => PreviewDeliveriesResponseEntity(
        serviceResponses:
            serviceResponses.map((e) => e.toEntity()).toList(),
        totalAmount: totalAmount,
      );

  factory PreviewDeliveriesResponseModel.fromEntity(
    PreviewDeliveriesResponseEntity entity,
  ) {
    return PreviewDeliveriesResponseModel(
      serviceResponses:
          entity.serviceResponses.map((e) => ServiceResponseModel.fromEntity(e)).toList(),
      totalAmount: entity.totalAmount,
    );
  }

  PreviewDeliveriesResponseModel copyWith({
    List<ServiceResponseModel>? serviceResponses,
    double? totalAmount,
  }) {
    return PreviewDeliveriesResponseModel(
      serviceResponses: serviceResponses ?? this.serviceResponses,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PreviewDeliveriesResponseModel &&
        const ListEquality().equals(other.serviceResponses, serviceResponses) &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode => Object.hash(
        const ListEquality().hash(serviceResponses),
        totalAmount,
      );

  @override
  String toString() {
    return 'PreviewDeliveriesResponseModel(serviceResponses: $serviceResponses, totalAmount: $totalAmount)';
  }
}