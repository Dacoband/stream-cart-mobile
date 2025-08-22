import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/cart_live/price_data_live_entity.dart';

part 'price_data_live_model.g.dart';

@JsonSerializable()
class PriceDataLiveModel extends PriceDataLiveEntity {
  const PriceDataLiveModel({
    required super.currentPrice,
    required super.originalPrice,
    required super.discount,
  });

  factory PriceDataLiveModel.fromJson(Map<String, dynamic> json) => _$PriceDataLiveModelFromJson(json);
  Map<String, dynamic> toJson() => _$PriceDataLiveModelToJson(this);

  PriceDataLiveEntity toEntity() => PriceDataLiveEntity(
    currentPrice: currentPrice,
    originalPrice: originalPrice,
    discount: discount,
  );

  factory PriceDataLiveModel.fromEntity(PriceDataLiveEntity entity) {
    return PriceDataLiveModel(
      currentPrice: entity.currentPrice,
      originalPrice: entity.originalPrice,
      discount: entity.discount,
    );
  }

  PriceDataLiveModel copyWith({
    double? currentPrice,
    double? originalPrice,
    double? discount,
  }) {
    return PriceDataLiveModel(
      currentPrice: currentPrice ?? this.currentPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
    );
  }
}
