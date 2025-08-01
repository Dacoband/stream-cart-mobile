import '../../../domain/entities/products/product_detail_entity.dart';

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
  final String weight;
  final String dimension;
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
  final List<ProductVariantModel> variants;

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
    required this.dimension,
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
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      quantitySold: json['quantitySold'] ?? 0,
      weight: json['weight'] ?? '',
      dimension: json['dimension'] ?? '',
      primaryImage: List<String>.from(json['primaryImage'] ?? []),
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      shopStartTime: json['shopStartTime'] ?? '',
      shopCompleteRate: (json['shopCompleteRate'] ?? 0).toDouble(),
      shopTotalReview: json['shopTotalReview'] ?? 0,
      shopRatingAverage: (json['shopRatingAverage'] ?? 0).toDouble(),
      shopLogo: json['shopLogo'] ?? '',
      shopTotalProduct: json['shopTotalProduct'] ?? 0,
      attributes: (json['attributes'] as List? ?? [])
          .map((attr) => ProductAttributeModel.fromJson(attr))
          .toList(),
      variants: (json['variants'] as List? ?? [])
          .map((variant) => ProductVariantModel.fromJson(variant))
          .toList(),
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
      dimension: dimension,
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

class ProductVariantModel {
  final String variantId;
  final Map<String, dynamic> attributeValues;
  final int stock;
  final double price;
  final double flashSalePrice;
  final String? variantImage;

  const ProductVariantModel({
    required this.variantId,
    required this.attributeValues,
    required this.stock,
    required this.price,
    required this.flashSalePrice,
    this.variantImage,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variantId'] ?? '',
      attributeValues: Map<String, dynamic>.from(json['attributeValues'] ?? {}),
      stock: json['stock'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      flashSalePrice: (json['flashSalePrice'] ?? 0).toDouble(),
      variantImage: json['variantImage'],
    );
  }

  ProductVariant toEntity() {
    return ProductVariant(
      variantId: variantId,
      attributeValues: attributeValues,
      stock: stock,
      price: price,
      flashSalePrice: flashSalePrice,
      variantImage: variantImage,
    );
  }
}
