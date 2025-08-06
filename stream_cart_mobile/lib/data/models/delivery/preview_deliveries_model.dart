import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import '../../../domain/entities/deliveries/preview_deliveries_entity.dart';
import 'from_shop_model.dart';

part 'preview_deliveries_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviewDeliveriesModel {
  final List<FromShopModel> fromShops;
  final String toProvince;
  final String toDistrict;
  final String toWard;

  const PreviewDeliveriesModel({
    required this.fromShops,
    required this.toProvince,
    required this.toDistrict,
    required this.toWard,
  });

  factory PreviewDeliveriesModel.fromJson(Map<String, dynamic> json) =>
      _$PreviewDeliveriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewDeliveriesModelToJson(this);

  factory PreviewDeliveriesModel.fromEntity(PreviewDeliveriesEntity entity) =>
      PreviewDeliveriesModel(
        fromShops: entity.fromShops
            .map((e) => FromShopModel.fromEntity(e))
            .toList(),
        toProvince: entity.toProvince,
        toDistrict: entity.toDistrict,
        toWard: entity.toWard,
      );

  PreviewDeliveriesEntity toEntity() => PreviewDeliveriesEntity(
        fromShops: fromShops.map((e) => e.toEntity()).toList(),
        toProvince: toProvince,
        toDistrict: toDistrict,
        toWard: toWard,
      );

  PreviewDeliveriesModel copyWith({
    List<FromShopModel>? fromShops,
    String? toProvince,
    String? toDistrict,
    String? toWard,
  }) {
    return PreviewDeliveriesModel(
      fromShops: fromShops ?? this.fromShops,
      toProvince: toProvince ?? this.toProvince,
      toDistrict: toDistrict ?? this.toDistrict,
      toWard: toWard ?? this.toWard,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PreviewDeliveriesModel &&
        const ListEquality().equals(other.fromShops, fromShops) &&
        other.toProvince == toProvince &&
        other.toDistrict == toDistrict &&
        other.toWard == toWard;
  }

  @override
  int get hashCode => Object.hash(
        const ListEquality().hash(fromShops),
        toProvince,
        toDistrict,
        toWard,
      );

  @override
  String toString() {
    return 'PreviewDeliveriesModel(fromShops: $fromShops, toProvince: $toProvince, toDistrict: $toDistrict, toWard: $toWard)';
  }
}