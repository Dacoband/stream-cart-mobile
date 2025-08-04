import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String? variantId;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double totalPrice;
  final String? notes;
  final String? refundRequestId;
  final String productName;
  final String? productImageUrl;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.totalPrice,
    this.notes,
    this.refundRequestId,
    required this.productName,
    this.productImageUrl,
  });

  OrderItemEntity copyWith({
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
    return OrderItemEntity(
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
  List<Object?> get props => [
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
      ];

  @override
  String toString() {
    return 'OrderItemEntity(id: $id, orderId: $orderId, productId: $productId, variantId: $variantId, quantity: $quantity, unitPrice: $unitPrice, discountAmount: $discountAmount, totalPrice: $totalPrice, notes: $notes, refundRequestId: $refundRequestId, productName: $productName, productImageUrl: $productImageUrl)';
  }
}