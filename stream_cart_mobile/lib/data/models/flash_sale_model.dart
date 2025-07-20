import '../../domain/entities/flash_sale_entity.dart';

class FlashSaleModel extends FlashSaleEntity {
  const FlashSaleModel({
    required super.id,
    required super.productId,
    super.variantId,
    required super.flashSalePrice,
    required super.quantityAvailable,
    required super.quantitySold,
    required super.isActive,
    required super.startTime,
    required super.endTime,
  });

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantId'],
      flashSalePrice: (json['flashSalePrice'] ?? 0).toDouble(),
      quantityAvailable: json['quantityAvailable'] ?? 0,
      quantitySold: json['quantitySold'] ?? 0,
      isActive: json['isActive'] ?? false,
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'variantId': variantId,
      'flashSalePrice': flashSalePrice,
      'quantityAvailable': quantityAvailable,
      'quantitySold': quantitySold,
      'isActive': isActive,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  FlashSaleEntity toEntity() {
    return FlashSaleEntity(
      id: id,
      productId: productId,
      variantId: variantId,
      flashSalePrice: flashSalePrice,
      quantityAvailable: quantityAvailable,
      quantitySold: quantitySold,
      isActive: isActive,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
