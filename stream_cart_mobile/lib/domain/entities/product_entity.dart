import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String productName;
  final String description;
  final String sku;
  final String categoryId;
  final double basePrice;
  final double discountPrice;
  final int stockQuantity;
  final bool isActive;
  final double weight;
  final String dimensions;
  final bool hasVariant;
  final int quantitySold;
  final String shopId;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;

  const ProductEntity({
    required this.id,
    required this.productName,
    required this.description,
    required this.sku,
    required this.categoryId,
    required this.basePrice,
    required this.discountPrice,
    required this.stockQuantity,
    required this.isActive,
    required this.weight,
    required this.dimensions,
    required this.hasVariant,
    required this.quantitySold,
    required this.shopId,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
  });

  double get finalPrice => discountPrice > 0 ? discountPrice : basePrice;
  bool get isOnSale => discountPrice > 0 && discountPrice < basePrice;

  @override
  List<Object?> get props => [
        id,
        productName,
        description,
        sku,
        categoryId,
        basePrice,
        discountPrice,
        stockQuantity,
        isActive,
        weight,
        dimensions,
        hasVariant,
        quantitySold,
        shopId,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
      ];
}
