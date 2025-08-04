import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/create_order_request_entity.dart';

part 'create_order_request_model.g.dart';

@JsonSerializable()
class CreateOrderRequestModel extends CreateOrderRequestEntity {
  @JsonKey(name: 'ordersByShop')
  @override
  final List<OrderByShopModel> ordersByShop;

  const CreateOrderRequestModel({
    required super.paymentMethod,
    required super.addressId,
    super.livestreamId,
    super.createdFromCommentId,
    required this.ordersByShop,
  }) : super(ordersByShop: ordersByShop);

  factory CreateOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestModelToJson(this);

  factory CreateOrderRequestModel.fromEntity(CreateOrderRequestEntity entity) {
    return CreateOrderRequestModel(
      paymentMethod: entity.paymentMethod,
      addressId: entity.addressId,
      livestreamId: entity.livestreamId,
      createdFromCommentId: entity.createdFromCommentId,
      ordersByShop: entity.ordersByShop
          .map((shop) => OrderByShopModel.fromEntity(shop))
          .toList(),
    );
  }

  CreateOrderRequestEntity toEntity() {
    return CreateOrderRequestEntity(
      paymentMethod: paymentMethod,
      addressId: addressId,
      livestreamId: livestreamId,
      createdFromCommentId: createdFromCommentId,
      ordersByShop: ordersByShop.map((shop) => shop.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class OrderByShopModel extends OrderByShopEntity {
  @override
  final List<CreateOrderItemModel> items;

  const OrderByShopModel({
    required super.shopId,
    super.shippingProviderId,
    required super.shippingFee,
    super.expectedDeliveryDay,
    super.voucherCode,
    required this.items,
    super.customerNotes,
  }) : super(items: items);

  factory OrderByShopModel.fromJson(Map<String, dynamic> json) =>
      _$OrderByShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderByShopModelToJson(this);

  factory OrderByShopModel.fromEntity(OrderByShopEntity entity) {
    return OrderByShopModel(
      shopId: entity.shopId,
      shippingProviderId: entity.shippingProviderId,
      shippingFee: entity.shippingFee,
      expectedDeliveryDay: entity.expectedDeliveryDay,
      voucherCode: entity.voucherCode,
      items: entity.items
          .map((item) => CreateOrderItemModel.fromEntity(item))
          .toList(),
      customerNotes: entity.customerNotes,
    );
  }

  OrderByShopEntity toEntity() {
    return OrderByShopEntity(
      shopId: shopId,
      shippingProviderId: shippingProviderId,
      shippingFee: shippingFee,
      expectedDeliveryDay: expectedDeliveryDay,
      voucherCode: voucherCode,
      items: items.map((item) => item.toEntity()).toList(),
      customerNotes: customerNotes,
    );
  }
}

@JsonSerializable()
class CreateOrderItemModel extends CreateOrderItemEntity {
  const CreateOrderItemModel({
    required super.productId,
    super.variantId,
    required super.quantity,
  });

  factory CreateOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderItemModelToJson(this);

  factory CreateOrderItemModel.fromEntity(CreateOrderItemEntity entity) {
    return CreateOrderItemModel(
      productId: entity.productId,
      variantId: entity.variantId,
      quantity: entity.quantity,
    );
  }

  CreateOrderItemEntity toEntity() {
    return CreateOrderItemEntity(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
    );
  }
}