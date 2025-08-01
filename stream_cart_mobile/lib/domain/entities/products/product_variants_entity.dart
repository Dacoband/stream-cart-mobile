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
      ];
}