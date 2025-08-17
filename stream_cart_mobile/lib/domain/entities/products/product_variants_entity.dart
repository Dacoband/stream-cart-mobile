import 'package:equatable/equatable.dart';

class ProductVariantEntity extends Equatable {
  final String id;
  final String productId;
  final String sku;
  final double price;
  final double flashSalePrice;
  final int stock;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;
  final Map<String, String> attributeValues;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final String? variantImage;

  const ProductVariantEntity({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.flashSalePrice,
    required this.stock,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
    this.attributeValues = const {},
    this.weight,
    this.length,
    this.width,
    this.height,
    this.variantImage,
  });

  ProductVariantEntity copyWith({
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
    Map<String, String>? attributeValues,
    double? weight,
    double? length,
    double? width,
    double? height,
    String? variantImage,
  }) {
    return ProductVariantEntity(
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
      attributeValues: attributeValues ?? this.attributeValues,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      variantImage: variantImage ?? this.variantImage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        sku,
        price,
        flashSalePrice,
        stock,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
        attributeValues,
        weight,
        length,
        width,
        height,
        variantImage,
      ];
}