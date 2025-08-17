import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import '../../../domain/entities/deliveries/from_shop_entity.dart';
import 'shipping_item_model.dart';

part 'from_shop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FromShopModel {
  final String fromShopId;
  final List<ShippingItemModel> items;

  const FromShopModel({
    required this.fromShopId,
    required this.items,
  });

  factory FromShopModel.fromJson(Map<String, dynamic> json) =>
      _$FromShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$FromShopModelToJson(this);

  factory FromShopModel.fromEntity(FromShopEntity entity) => FromShopModel(
        fromShopId: entity.fromShopId,
        items: entity.items
            .map((e) => ShippingItemModel.fromEntity(e))
            .toList(),
      );

  FromShopEntity toEntity() => FromShopEntity(
        fromShopId: fromShopId,
        items: items.map((e) => e.toEntity()).toList(),
      );

  FromShopModel copyWith({
    String? fromShopId,
    List<ShippingItemModel>? items,
  }) {
    return FromShopModel(
      fromShopId: fromShopId ?? this.fromShopId,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FromShopModel &&
        other.fromShopId == fromShopId &&
        const ListEquality().equals(other.items, items);
  }

  @override
  int get hashCode => Object.hash(
        fromShopId,
        const ListEquality().hash(items),
      );

  @override
  String toString() =>
      'FromShopModel(fromShopId: $fromShopId, items: $items)';
}