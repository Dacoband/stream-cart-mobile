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
  });

  factory ProductVariantsModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantsModel(
      id: json['id']?.toString() ?? '', 
      productId: json['productId']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      flashSalePrice: (json['flashSalePrice'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(), 
      createdBy: json['createdBy']?.toString() ?? 'Anonymous',
      lastModifiedAt: json['lastModifiedAt'] != null 
          ? DateTime.tryParse(json['lastModifiedAt'].toString()) 
          : null,
      lastModifiedBy: json['lastModifiedBy']?.toString(),
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

  ProductVariantEntity toEntity() {
  return ProductVariantEntity(
    id: id,
    productId: productId,
    sku: sku,
    price: price,
    flashSalePrice: flashSalePrice,
    stock: stock,
    createdAt: createdAt,
    createdBy: createdBy,
    lastModifiedAt: lastModifiedAt,
    lastModifiedBy: lastModifiedBy,
  );
}
}