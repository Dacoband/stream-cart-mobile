import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/deliveries/shipping_item_entity.dart';

part 'shipping_item_model.g.dart';

@JsonSerializable()
class ShippingItemModel extends ShippingItemEntity {
  const ShippingItemModel({
    required super.name,
    required super.quantity,
    required super.weight,
    super.length,
    super.width,
    super.height,
  });

  factory ShippingItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingItemModelToJson(this);

  ShippingItemEntity toEntity() {
    return ShippingItemEntity(
      name: name,
      quantity: quantity,
      weight: weight,
      length: length,
      width: width,
      height: height,
    );
  }

  factory ShippingItemModel.fromEntity(ShippingItemEntity entity) {
    return ShippingItemModel(
      name: entity.name,
      quantity: entity.quantity,
      weight: entity.weight,
      length: entity.length,
      width: entity.width,
      height: entity.height,
    );
  }

  ShippingItemModel copyWith({
    String? name,
    int? quantity,
    double? weight,
    double? length,
    double? width,
    double? height,
  }) {
    return ShippingItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShippingItemModel &&
        other.name == name &&
        other.quantity == quantity &&
        other.weight == weight &&
        other.length == length &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode {
    return Object.hash(name, quantity, weight, length, width, height);
  }

  @override
  String toString() {
    return 'ShippingItemModel(name: $name, quantity: $quantity, weight: $weight, length: $length, width: $width, height: $height)';
  }
}