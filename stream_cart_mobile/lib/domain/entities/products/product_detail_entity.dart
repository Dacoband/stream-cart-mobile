import 'package:equatable/equatable.dart';
import 'product_variants_entity.dart';
import 'product_detail_attribute_entity.dart'; // Import entity mới

class ProductDetailEntity extends Equatable {
  final String productId;
  final String productName;
  final String description;
  final String categoryId;
  final String categoryName;
  final double basePrice;
  final double discountPrice;
  final double finalPrice;
  final int stockQuantity;
  final int quantitySold;
  final double weight;
  final double length;
  final double width;
  final double height;
  final List<String> primaryImage;
  final String shopId;
  final String shopName;
  final DateTime shopStartTime;
  final double shopCompleteRate;
  final int shopTotalReview;
  final double shopRatingAverage;
  final String? shopLogo;
  final int shopTotalProduct;
  final List<ProductDetailAttributeEntity> attributes; // SỬA: Sử dụng entity mới
  final List<ProductVariantEntity> variants;

  const ProductDetailEntity({
    required this.productId,
    required this.productName,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.basePrice,
    required this.discountPrice,
    required this.finalPrice,
    required this.stockQuantity,
    required this.quantitySold,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.primaryImage,
    required this.shopId,
    required this.shopName,
    required this.shopStartTime,
    required this.shopCompleteRate,
    required this.shopTotalReview,
    required this.shopRatingAverage,
    this.shopLogo,
    required this.shopTotalProduct,
    required this.attributes,
    required this.variants,
  });

  @override
  List<Object?> get props => [
    productId, productName, description, categoryId, categoryName,
    basePrice, discountPrice, finalPrice, stockQuantity, quantitySold,
    weight, length, width, height, primaryImage, shopId, shopName,
    shopStartTime, shopCompleteRate, shopTotalReview, shopRatingAverage,
    shopLogo, shopTotalProduct, attributes, variants,
  ];
}