import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  bool get isOnSale => discountPrice > 0 && discountPrice < basePrice;
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
  final bool hasVariant;
  final int quantitySold;
  final String shopId;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;
  final bool hasPrimaryImage;
  final String primaryImageUrl;

  const ProductEntity({
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


  @override
  List<Object?> get props => [
        id,
        productName,
        description,
        sku,
        categoryId,
        basePrice,
        discountPrice,
        finalPrice,
        stockQuantity,
        isActive,
        weight,
        length,
        width,
        height,
        hasVariant,
        quantitySold,
        shopId,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
        hasPrimaryImage,
        primaryImageUrl,
      ];
}
