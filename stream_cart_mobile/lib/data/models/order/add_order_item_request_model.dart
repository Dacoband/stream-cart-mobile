import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/add_order_item_request_entity.dart';

part 'add_order_item_request_model.g.dart';

@JsonSerializable()
class AddOrderItemRequestModel extends AddOrderItemRequestEntity {
  const AddOrderItemRequestModel({
    required super.productId,
    super.variantId,
    required super.quantity,
  });

  factory AddOrderItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddOrderItemRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddOrderItemRequestModelToJson(this);

  factory AddOrderItemRequestModel.fromEntity(AddOrderItemRequestEntity entity) {
    return AddOrderItemRequestModel(
      productId: entity.productId,
      variantId: entity.variantId,
      quantity: entity.quantity,
    );
  }

  AddOrderItemRequestEntity toEntity() {
    return AddOrderItemRequestEntity(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
    );
  }

  AddOrderItemRequestModel copyWith({
    String? productId,
    String? variantId,
    int? quantity,
  }) {
    return AddOrderItemRequestModel(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }
}