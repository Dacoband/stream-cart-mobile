import '../../../domain/entities/livestream/livestream_product_entity.dart';

class LiveStreamProductModel {
  final String id;
  final String livestreamId;
  final String productId;
  final String? variantId;
  final String? flashSaleId;
  final bool isPin;
  final double originalPrice;
  final double price;
  final int stock;
  final int productStock;
  final String createdAt;
  final String lastModifiedAt;
  final String sku;
  final String productName;
  final String productImageUrl;
  final String? variantName;

  const LiveStreamProductModel({
    required this.id,
    required this.livestreamId,
    required this.productId,
    this.variantId,
    this.flashSaleId,
    required this.isPin,
  required this.originalPrice,
    required this.price,
    required this.stock,
  required this.productStock,
    required this.createdAt,
    required this.lastModifiedAt,
  required this.sku,
    required this.productName,
    required this.productImageUrl,
    this.variantName,
  });

  factory LiveStreamProductModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamProductModel(
      id: json['id'] ?? '',
      livestreamId: json['livestreamId'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantId'],
      flashSaleId: json['flashSaleId'],
      isPin: json['isPin'] ?? false,
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      productStock: json['productStock'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      lastModifiedAt: json['lastModifiedAt'] ?? '',
      sku: json['sku'] ?? '',
      productName: json['productName'] ?? '',
      productImageUrl: json['productImageUrl'] ?? '',
      variantName: json['variantName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'livestreamId': livestreamId,
        'productId': productId,
        'variantId': variantId,
        'flashSaleId': flashSaleId,
        'isPin': isPin,
        'originalPrice': originalPrice,
        'price': price,
        'stock': stock,
        'productStock': productStock,
        'createdAt': createdAt,
        'lastModifiedAt': lastModifiedAt,
        'sku': sku,
        'productName': productName,
        'productImageUrl': productImageUrl,
        'variantName': variantName,
      };

  LiveStreamProductEntity toEntity() => LiveStreamProductEntity(
        id: id,
        livestreamId: livestreamId,
        productId: productId,
        variantId: variantId,
        flashSaleId: flashSaleId,
        isPin: isPin,
        originalPrice: originalPrice,
        price: price,
        stock: stock,
        productStock: productStock,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        lastModifiedAt: DateTime.tryParse(lastModifiedAt) ?? DateTime.now(),
        sku: sku,
        productName: productName,
        productImageUrl: productImageUrl,
        variantName: variantName,
      );
}
