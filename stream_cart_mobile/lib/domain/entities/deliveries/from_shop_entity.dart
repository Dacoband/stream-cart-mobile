import 'package:equatable/equatable.dart';
import 'shipping_item_entity.dart';

class FromShopEntity extends Equatable {
  final String fromShopId;
  final List<ShippingItemEntity> items;

  const FromShopEntity({
    required this.fromShopId,
    required this.items,
  });

  FromShopEntity copyWith({
    String? fromShopId,
    List<ShippingItemEntity>? items,
  }) {
    return FromShopEntity(
      fromShopId: fromShopId ?? this.fromShopId,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [fromShopId, items];

  @override
  String toString() {
    return 'FromShopEntity(fromShopId: $fromShopId, items: $items)';
  }
}