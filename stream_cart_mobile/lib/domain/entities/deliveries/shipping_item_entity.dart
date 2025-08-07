import 'package:equatable/equatable.dart';

class ShippingItemEntity extends Equatable {
  final String name;
  final int quantity;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;

  const ShippingItemEntity({
    required this.name,
    required this.quantity,
    this.weight,
    this.length,
    this.width,
    this.height,
  });

  ShippingItemEntity copyWith({
    String? name,
    int? quantity,
    double? weight,
    double? length,
    double? width,
    double? height,
  }) {
    return ShippingItemEntity(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [
        name,
        quantity,
        weight,
        length,
        width,
        height,
      ];

  @override
  String toString() {
    return 'ShippingItemEntity(name: $name, quantity: $quantity, weight: $weight, length: $length, width: $width, height: $height)';
  }
}