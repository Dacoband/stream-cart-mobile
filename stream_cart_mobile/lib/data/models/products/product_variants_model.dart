import '../../../domain/entities/products/product_variants_entity.dart';

class ProductVariantsModel extends ProductVariantEntity {
  const ProductVariantsModel({
    required super.id,
    required super.productId,
    required super.sku,
    required super.price,
    required super.flashSalePrice,
    required super.stock,
    required super.createdAt,
    required super.createdBy,
    super.lastModifiedAt,
    super.lastModifiedBy,
    super.attributeValues,
    super.weight,
    super.length,
    super.width,
    super.height,
    super.variantImage,
  });

  factory ProductVariantsModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parse variant: ${json['variantId'] ?? json['id']}');
      
      return ProductVariantsModel(
        // SỬA: Sử dụng đúng field names
        id: json['id']?.toString() ?? json['variantId']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        sku: json['sku']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        flashSalePrice: (json['flashSalePrice'] as num?)?.toDouble() ?? 0.0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        // Parse DateTime từ string
        createdAt: json['createdAt'] != null 
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
        createdBy: json['createdBy']?.toString() ?? 'System',
        lastModifiedAt: json['lastModifiedAt'] != null 
            ? DateTime.tryParse(json['lastModifiedAt'].toString())
            : null,
        lastModifiedBy: json['lastModifiedBy']?.toString(),
        // Thêm các field mới từ product detail API
        attributeValues: json['attributeValues'] != null
            ? Map<String, String>.from(json['attributeValues'] as Map)
            : {},
        weight: json['weight'] != null 
            ? (json['weight'] as num).toDouble()
            : null,
        length: json['length'] != null 
            ? (json['length'] as num).toDouble()
            : null,
        width: json['width'] != null 
            ? (json['width'] as num).toDouble()
            : null,
        height: json['height'] != null 
            ? (json['height'] as num).toDouble()
            : null,
        variantImage: json['variantImage']?.toString(),
      );
    } catch (e, stackTrace) {
      print('❌ Lỗi parse ProductVariantsModel: $e');
      print('📍 StackTrace: $stackTrace');
      print('📄 Variant JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variantId': id, // Include both for compatibility
      'productId': productId,
      'sku': sku,
      'price': price,
      'flashSalePrice': flashSalePrice,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
      'attributeValues': attributeValues,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'variantImage': variantImage,
    };
  }

  factory ProductVariantsModel.fromEntity(ProductVariantEntity entity) {
    return ProductVariantsModel(
      id: entity.id,
      productId: entity.productId,
      sku: entity.sku,
      price: entity.price,
      flashSalePrice: entity.flashSalePrice,
      stock: entity.stock,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      lastModifiedAt: entity.lastModifiedAt,
      lastModifiedBy: entity.lastModifiedBy,
      attributeValues: entity.attributeValues,
      weight: entity.weight,
      length: entity.length,
      width: entity.width,
      height: entity.height,
      variantImage: entity.variantImage,
    );
  }
}