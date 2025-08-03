import 'package:equatable/equatable.dart';
import 'product_variants_entity.dart';
import 'product_attribute_entity.dart';

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
  final List<ProductAttributeEntity> attributes;
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

  // Computed property để tạo dimension string
  String get dimension => '${length}x${width}x${height}cm';

  ProductDetailEntity copyWith({
    String? productId,
    String? productName,
    String? description,
    String? categoryId,
    String? categoryName,
    double? basePrice,
    double? discountPrice,
    double? finalPrice,
    int? stockQuantity,
    int? quantitySold,
    double? weight,
    double? length,
    double? width,
    double? height,
    List<String>? primaryImage,
    String? shopId,
    String? shopName,
    DateTime? shopStartTime,
    double? shopCompleteRate,
    int? shopTotalReview,
    double? shopRatingAverage,
    String? shopLogo,
    int? shopTotalProduct,
    List<ProductAttributeEntity>? attributes,
    List<ProductVariantEntity>? variants,
  }) {
    return ProductDetailEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      basePrice: basePrice ?? this.basePrice,
      discountPrice: discountPrice ?? this.discountPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      quantitySold: quantitySold ?? this.quantitySold,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      primaryImage: primaryImage ?? this.primaryImage,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopStartTime: shopStartTime ?? this.shopStartTime,
      shopCompleteRate: shopCompleteRate ?? this.shopCompleteRate,
      shopTotalReview: shopTotalReview ?? this.shopTotalReview,
      shopRatingAverage: shopRatingAverage ?? this.shopRatingAverage,
      shopLogo: shopLogo ?? this.shopLogo,
      shopTotalProduct: shopTotalProduct ?? this.shopTotalProduct,
      attributes: attributes ?? this.attributes,
      variants: variants ?? this.variants,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    description,
    categoryId,
    categoryName,
    basePrice,
    discountPrice,
    finalPrice,
    stockQuantity,
    quantitySold,
    weight,
    length,
    width,
    height,
    primaryImage,
    shopId,
    shopName,
    shopStartTime,
    shopCompleteRate,
    shopTotalReview,
    shopRatingAverage,
    shopLogo,
    shopTotalProduct,
    attributes,
    variants,
  ];
}