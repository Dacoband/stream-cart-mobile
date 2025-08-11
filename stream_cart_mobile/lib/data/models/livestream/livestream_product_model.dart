import '../../../domain/entities/livestream/livestream_product_entity.dart';

class LiveStreamProductModel {
  final String id;
  final String livestreamId;
  final String productId;
  final String? variantId;
  final String? flashSaleId;
  final bool isPin;
  final double price;
  final int stock;
  final String createdAt;
  final String lastModifiedAt;
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
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.lastModifiedAt,
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
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      lastModifiedAt: json['lastModifiedAt'] ?? '',
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
        'price': price,
        'stock': stock,
        'createdAt': createdAt,
        'lastModifiedAt': lastModifiedAt,
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
        price: price,
        stock: stock,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        lastModifiedAt: DateTime.tryParse(lastModifiedAt) ?? DateTime.now(),
        productName: productName,
        productImageUrl: productImageUrl,
        variantName: variantName,
      );
}
