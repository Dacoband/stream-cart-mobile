import '../../../domain/entities/products/product_detail_entity.dart';
import 'product_variants_model.dart'; 
class ProductDetailModel {
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
  final String shopStartTime;
  final double shopCompleteRate;
  final int shopTotalReview;
  final double shopRatingAverage;
  final String shopLogo;
  final int shopTotalProduct;
  final List<ProductAttributeModel> attributes;
  final List<ProductVariantsModel> variants; 

  const ProductDetailModel({
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
    required this.shopLogo,
    required this.shopTotalProduct,
    required this.attributes,
    required this.variants,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      quantitySold: (json['quantitySold'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      primaryImage: List<String>.from(json['primaryImage'] ?? []),
      shopId: json['shopId']?.toString() ?? '',
      shopName: json['shopName']?.toString() ?? '',
      shopStartTime: json['shopStartTime']?.toString() ?? '',
      shopCompleteRate: (json['shopCompleteRate'] as num?)?.toDouble() ?? 0.0,
      shopTotalReview: (json['shopTotalReview'] as num?)?.toInt() ?? 0,
      shopRatingAverage: (json['shopRatingAverage'] as num?)?.toDouble() ?? 0.0,
      shopLogo: json['shopLogo']?.toString() ?? '',
      shopTotalProduct: (json['shopTotalProduct'] as num?)?.toInt() ?? 0,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((attr) => ProductAttributeModel.fromJson(attr as Map<String, dynamic>))
          .toList() ?? [],
      variants: (json['variants'] as List<dynamic>?)
          ?.map((variant) => ProductVariantsModel.fromJson(variant as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  ProductDetailEntity toEntity() {
    return ProductDetailEntity(
      productId: productId,
      productName: productName,
      description: description,
      categoryId: categoryId,
      categoryName: categoryName,
      basePrice: basePrice,
      discountPrice: discountPrice,
      finalPrice: finalPrice,
      stockQuantity: stockQuantity,
      quantitySold: quantitySold,
      weight: weight,
      length: length,
      width: width,
      height: height,
      primaryImage: primaryImage,
      shopId: shopId,
      shopName: shopName,
      shopStartTime: DateTime.tryParse(shopStartTime) ?? DateTime.now(),
      shopCompleteRate: shopCompleteRate,
      shopTotalReview: shopTotalReview,
      shopRatingAverage: shopRatingAverage,
      shopLogo: shopLogo,
      shopTotalProduct: shopTotalProduct,
      attributes: attributes.map((attr) => attr.toEntity()).toList(),
      variants: variants.map((variant) => variant.toEntity()).toList(), 
    );
  }
}

class ProductAttributeModel {
  final String attributeId;
  final String attributeName;
  final String attributeValue;

  const ProductAttributeModel({
    required this.attributeId,
    required this.attributeName,
    required this.attributeValue,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      attributeId: json['attributeId'] ?? '',
      attributeName: json['attributeName'] ?? '',
      attributeValue: json['attributeValue'] ?? '',
    );
  }

  ProductAttribute toEntity() {
    return ProductAttribute(
      attributeId: attributeId,
      attributeName: attributeName,
      attributeValue: attributeValue,
    );
  }
}
