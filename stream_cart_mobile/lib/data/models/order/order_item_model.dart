import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/order_item_entity.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productId,
    super.variantId,
    required super.quantity,
    required super.unitPrice,
    required super.discountAmount,
    required super.totalPrice,
    super.notes,
    super.refundRequestId,
    required super.productName,
    super.productImageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      orderId: orderId,
      productId: productId,
      variantId: variantId,
      quantity: quantity,
      unitPrice: unitPrice,
      discountAmount: discountAmount,
      totalPrice: totalPrice,
      notes: notes,
      refundRequestId: refundRequestId,
      productName: productName,
      productImageUrl: productImageUrl,
    );
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      productId: entity.productId,
      variantId: entity.variantId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      discountAmount: entity.discountAmount,
      totalPrice: entity.totalPrice,
      notes: entity.notes,
      refundRequestId: entity.refundRequestId,
      productName: entity.productName,
      productImageUrl: entity.productImageUrl,
    );
  }

  OrderItemModel copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? variantId,
    int? quantity,
    double? unitPrice,
    double? discountAmount,
    double? totalPrice,
    String? notes,
    String? refundRequestId,
    String? productName,
    String? productImageUrl,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      refundRequestId: refundRequestId ?? this.refundRequestId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItemModel &&
        other.id == id &&
        other.orderId == orderId &&
        other.productId == productId &&
        other.variantId == variantId &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.discountAmount == discountAmount &&
        other.totalPrice == totalPrice &&
        other.notes == notes &&
        other.refundRequestId == refundRequestId &&
        other.productName == productName &&
        other.productImageUrl == productImageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      orderId,
      productId,
      variantId,
      quantity,
      unitPrice,
      discountAmount,
      totalPrice,
      notes,
      refundRequestId,
      productName,
      productImageUrl,
    );
  }

  @override
  String toString() {
    return 'OrderItemModel(id: $id, orderId: $orderId, productId: $productId, variantId: $variantId, quantity: $quantity, unitPrice: $unitPrice, discountAmount: $discountAmount, totalPrice: $totalPrice, notes: $notes, refundRequestId: $refundRequestId, productName: $productName, productImageUrl: $productImageUrl)';
  }
}