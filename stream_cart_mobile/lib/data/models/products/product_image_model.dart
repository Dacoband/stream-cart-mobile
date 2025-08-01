import '../../domain/entities/product_image_entity.dart';

class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    required super.id,
    required super.productId,
    super.variantId,
    required super.imageUrl,
    required super.isPrimary,
    required super.displayOrder,
    super.altText,
    required super.createdAt,
    required super.createdBy,
    required super.lastModifiedAt,
    required super.lastModifiedBy,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantId'],
      imageUrl: json['imageUrl'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
      altText: json['altText'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      createdBy: json['createdBy'] ?? '',
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] ?? DateTime.now().toIso8601String()),
      lastModifiedBy: json['lastModifiedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'variantId': variantId,
      'imageUrl': imageUrl,
      'isPrimary': isPrimary,
      'displayOrder': displayOrder,
      'altText': altText,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  ProductImageEntity toEntity() {
    return ProductImageEntity(
      id: id,
      productId: productId,
      variantId: variantId,
      imageUrl: imageUrl,
      isPrimary: isPrimary,
      displayOrder: displayOrder,
      altText: altText,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt,
      lastModifiedBy: lastModifiedBy,
    );
  }
}
