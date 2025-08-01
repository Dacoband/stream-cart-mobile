import '../../domain/entities/product_entity.dart';

class ProductResponseModel {
  final bool success;
  final String message;
  final List<ProductModel> data;
  final List<String> errors;

  const ProductResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList()
          : [],
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }
}

class ProductModel {
  final String id;
  final String productName;
  final String description;
  final String sku;
  final String categoryId;
  final double basePrice;
  final double discountPrice;
  final double finalPrice;
  final int stockQuantity;
  final bool isActive;
  final double weight;
  final double length;
  final double width;
  final double height;
  final String dimensions;
  final bool hasVariant;
  final int quantitySold;
  final String shopId;
  final String createdAt;
  final String createdBy;
  final String? lastModifiedAt;
  final String? lastModifiedBy;
  final bool hasPrimaryImage;
  final String primaryImageUrl;

  const ProductModel({
    required this.id,
    required this.productName,
    required this.description,
    required this.sku,
    required this.categoryId,
    required this.basePrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.stockQuantity,
    required this.isActive,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.dimensions,
    required this.hasVariant,
    required this.quantitySold,
    required this.shopId,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
    required this.hasPrimaryImage,
    required this.primaryImageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      sku: json['sku'] ?? '',
      categoryId: json['categoryId'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      isActive: json['isActive'] ?? true,
      weight: (json['weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      dimensions: json['dimensions'] ?? '',
      hasVariant: json['hasVariant'] ?? false,
      quantitySold: json['quantitySold'] ?? 0,
      shopId: json['shopId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      lastModifiedAt: json['lastModifiedAt'],
      lastModifiedBy: json['lastModifiedBy'],
      hasPrimaryImage: json['hasPrimaryImage'] ?? false,
      primaryImageUrl: json['primaryImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'description': description,
      'sku': sku,
      'categoryId': categoryId,
      'basePrice': basePrice,
      'discountPrice': discountPrice,
      'finalPrice': finalPrice,
      'stockQuantity': stockQuantity,
      'isActive': isActive,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'hasVariant': hasVariant,
      'quantitySold': quantitySold,
      'shopId': shopId,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt,
      'lastModifiedBy': lastModifiedBy,
      'hasPrimaryImage': hasPrimaryImage,
      'primaryImageUrl': primaryImageUrl,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      productName: productName,
      description: description,
      sku: sku,
      categoryId: categoryId,
      basePrice: basePrice,
      discountPrice: discountPrice,
      finalPrice: finalPrice,
      stockQuantity: stockQuantity,
      isActive: isActive,
      weight: weight,
      length: length,
      width: width,
      height: height,
      hasVariant: hasVariant,
      quantitySold: quantitySold,
      shopId: shopId,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt != null ? DateTime.tryParse(lastModifiedAt!) : null,
      lastModifiedBy: lastModifiedBy,
      hasPrimaryImage: hasPrimaryImage,
      primaryImageUrl: primaryImageUrl,
    );
  }
}
