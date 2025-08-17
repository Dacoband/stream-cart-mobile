import 'package:equatable/equatable.dart';

class LiveStreamProductEntity extends Equatable {
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
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final String sku;
  final String productName;
  final String productImageUrl;
  final String? variantName;

  const LiveStreamProductEntity({
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

  LiveStreamProductEntity copyWith({
    String? id,
    String? livestreamId,
    String? productId,
    String? variantId,
    String? flashSaleId,
    bool? isPin,
    double? originalPrice,
    double? price,
    int? stock,
    int? productStock,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    String? sku,
    String? productName,
    String? productImageUrl,
    String? variantName,
  }) => LiveStreamProductEntity(
        id: id ?? this.id,
        livestreamId: livestreamId ?? this.livestreamId,
        productId: productId ?? this.productId,
        variantId: variantId ?? this.variantId,
        flashSaleId: flashSaleId ?? this.flashSaleId,
        isPin: isPin ?? this.isPin,
        originalPrice: originalPrice ?? this.originalPrice,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        productStock: productStock ?? this.productStock,
        createdAt: createdAt ?? this.createdAt,
        lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
        sku: sku ?? this.sku,
        productName: productName ?? this.productName,
        productImageUrl: productImageUrl ?? this.productImageUrl,
        variantName: variantName ?? this.variantName,
      );

  @override
  List<Object?> get props => [
        id,
        livestreamId,
        productId,
        variantId,
        flashSaleId,
        isPin,
        originalPrice,
        price,
        stock,
        productStock,
        createdAt,
        lastModifiedAt,
        sku,
        productName,
        productImageUrl,
        variantName,
      ];
}
