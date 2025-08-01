import '../../domain/entities/product_variants_entity.dart';

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
  });

  factory ProductVariantsModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantsModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      flashSalePrice: (json['flashSalePrice'] as num).toDouble(),
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      lastModifiedAt: json['lastModifiedAt'] != null 
          ? DateTime.parse(json['lastModifiedAt'] as String) 
          : null,
      lastModifiedBy: json['lastModifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'sku': sku,
      'price': price,
      'flashSalePrice': flashSalePrice,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  ProductVariantsModel copyWith({
    String? id,
    String? productId,
    String? sku,
    double? price,
    double? flashSalePrice,
    int? stock,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
  }) {
    return ProductVariantsModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      flashSalePrice: flashSalePrice ?? this.flashSalePrice,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }
}