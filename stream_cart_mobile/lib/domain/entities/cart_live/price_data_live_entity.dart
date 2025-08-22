import 'package:equatable/equatable.dart';

class PriceDataLiveEntity extends Equatable {
  final double currentPrice;
  final double originalPrice;
  final double discount;

  const PriceDataLiveEntity({
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
  });

  PriceDataLiveEntity copyWith({
    double? currentPrice,
    double? originalPrice,
    double? discount,
  }) {
    return PriceDataLiveEntity(
      currentPrice: currentPrice ?? this.currentPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [currentPrice, originalPrice, discount];

  @override
  String toString() => 'PriceDataLiveEntity(currentPrice: $currentPrice, originalPrice: $originalPrice, discount: $discount)';
}
