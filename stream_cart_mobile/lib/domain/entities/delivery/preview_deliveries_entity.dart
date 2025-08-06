import 'package:equatable/equatable.dart';
import 'from_shop_entity.dart';

class PreviewDeliveriesEntity extends Equatable {
  final List<FromShopEntity> fromShops;
  final String toProvince;
  final String toDistrict;
  final String toWard;

  const PreviewDeliveriesEntity({
    required this.fromShops,
    required this.toProvince,
    required this.toDistrict,
    required this.toWard,
  });

  PreviewDeliveriesEntity copyWith({
    List<FromShopEntity>? fromShops,
    String? toProvince,
    String? toDistrict,
    String? toWard,
  }) {
    return PreviewDeliveriesEntity(
      fromShops: fromShops ?? this.fromShops,
      toProvince: toProvince ?? this.toProvince,
      toDistrict: toDistrict ?? this.toDistrict,
      toWard: toWard ?? this.toWard,
    );
  }

  @override
  List<Object?> get props => [fromShops, toProvince, toDistrict, toWard];

  @override
  String toString() {
    return 'PreviewDeliveriesEntity(fromShops: $fromShops, toProvince: $toProvince, toDistrict: $toDistrict, toWard: $toWard)';
  }
}