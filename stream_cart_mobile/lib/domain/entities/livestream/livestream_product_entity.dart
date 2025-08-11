import 'package:equatable/equatable.dart';

class LiveStreamProductEntity extends Equatable {
  final String id;
  final String livestreamId;
  final String productId;
  final String? variantId;
  final String? flashSaleId;
  final bool isPin;
  final double price;
  final int stock;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
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
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.lastModifiedAt,
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
    double? price,
    int? stock,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
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
        price: price ?? this.price,
        stock: stock ?? this.stock,
        createdAt: createdAt ?? this.createdAt,
        lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
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
        price,
        stock,
        createdAt,
        lastModifiedAt,
        productName,
        productImageUrl,
        variantName,
      ];
}
