import 'package:equatable/equatable.dart';

class AddOrderItemRequestEntity extends Equatable {
  final String productId;
  final String? variantId;
  final int quantity;

  const AddOrderItemRequestEntity({
    required this.productId,
    this.variantId,
    required this.quantity,
  });

  AddOrderItemRequestEntity copyWith({
    String? productId,
    String? variantId,
    int? quantity,
  }) {
    return AddOrderItemRequestEntity(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, variantId, quantity];

  @override
  String toString() {
    return 'AddOrderItemRequestEntity(productId: $productId, variantId: $variantId, quantity: $quantity)';
  }
}