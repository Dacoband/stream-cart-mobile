class ProductImageEntity {
  final String id;
  final String productId;
  final String? variantId;
  final String imageUrl;
  final bool isPrimary;
  final int displayOrder;
  final String? altText;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastModifiedAt;
  final String lastModifiedBy;

  const ProductImageEntity({
    required this.id,
    required this.productId,
    this.variantId,
    required this.imageUrl,
    required this.isPrimary,
    required this.displayOrder,
    this.altText,
    required this.createdAt,
    required this.createdBy,
    required this.lastModifiedAt,
    required this.lastModifiedBy,
  });
}
