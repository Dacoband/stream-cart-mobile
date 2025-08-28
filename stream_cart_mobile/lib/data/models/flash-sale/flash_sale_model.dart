import '../../../domain/entities/flash-sale/flash_sale_entity.dart';

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
  super.slot = 0,
  super.productName,
  super.productImageUrl,
  super.variantName,
  });

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantId'],
      flashSalePrice: (json['flashSalePrice'] as num?)?.toDouble() ?? 0,
      quantityAvailable: json['quantityAvailable'] ?? 0,
      quantitySold: json['quantitySold'] ?? 0,
      isActive: json['isActive'] ?? false,
      startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] ?? '') ?? DateTime.now(),
      slot: json['slot'] ?? 0,
      productName: json['productName']?.toString(),
      productImageUrl: json['productImageUrl']?.toString(),
      variantName: json['variantName']?.toString(),
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
  'slot': slot,
  'productName': productName,
  'productImageUrl': productImageUrl,
  'variantName': variantName,
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
      slot: slot,
      productName: productName,
      productImageUrl: productImageUrl,
      variantName: variantName,
    );
  }
}
