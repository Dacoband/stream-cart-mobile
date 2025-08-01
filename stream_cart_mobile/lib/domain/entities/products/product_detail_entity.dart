class ProductDetailEntity {
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
  final DateTime shopStartTime;
  final double shopCompleteRate;
  final int shopTotalReview;
  final double shopRatingAverage;
  final String shopLogo;
  final int shopTotalProduct;
  final List<ProductAttribute> attributes;
  final List<ProductVariant> variants;

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
}

class ProductAttribute {
  final String attributeId;
  final String attributeName;
  final String attributeValue;

  const ProductAttribute({
    required this.attributeId,
    required this.attributeName,
    required this.attributeValue,
  });
}

class ProductVariant {
  final String variantId;
  final Map<String, dynamic> attributeValues;
  final int stock;
  final double price;
  final double flashSalePrice;
  final String? variantImage;

  const ProductVariant({
    required this.variantId,
    required this.attributeValues,
    required this.stock,
    required this.price,
    required this.flashSalePrice,
    this.variantImage,
  });
}
