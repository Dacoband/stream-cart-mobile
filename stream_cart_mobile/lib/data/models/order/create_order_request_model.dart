import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/create_order_request_entity.dart';

part 'create_order_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrderRequestModel extends CreateOrderRequestEntity {
  @JsonKey(name: 'paymentMethod')
  @override
  final String paymentMethod;
  
  @JsonKey(name: 'addressId')
  @override
  final String addressId;
  
  @JsonKey(name: 'livestreamId')
  @override
  final String? livestreamId;
  
  @JsonKey(name: 'createdFromCommentId')
  @override
  final String? createdFromCommentId;
  
  @JsonKey(name: 'ordersByShop')
  @override
  final List<OrderByShopModel> ordersByShop;

  const CreateOrderRequestModel({
    required this.paymentMethod,
    required this.addressId,
    this.livestreamId,
    this.createdFromCommentId,
    required this.ordersByShop,
  }) : super(
          paymentMethod: paymentMethod,
          addressId: addressId,
          livestreamId: livestreamId,
          createdFromCommentId: createdFromCommentId,
          ordersByShop: ordersByShop,
        );

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

@JsonSerializable(explicitToJson: true)
class OrderByShopModel extends OrderByShopEntity {
  @JsonKey(name: 'shopId')
  @override
  final String shopId;
  
  @JsonKey(name: 'shippingProviderId')
  @override
  final String? shippingProviderId;
  
  @JsonKey(name: 'shippingFee')
  @override
  final double shippingFee;
  
  @JsonKey(name: 'expectedDeliveryDay')
  @override
  final String? expectedDeliveryDay;
  
  @JsonKey(name: 'voucherCode')
  @override
  final String? voucherCode;
  
  @JsonKey(name: 'items')
  @override
  final List<CreateOrderItemModel> items;
  
  @JsonKey(name: 'customerNotes')
  @override
  final String? customerNotes;

  const OrderByShopModel({
    required this.shopId,
    this.shippingProviderId,
    required this.shippingFee,
    this.expectedDeliveryDay,
    this.voucherCode,
    required this.items,
    this.customerNotes,
  }) : super(
          shopId: shopId,
          shippingProviderId: shippingProviderId,
          shippingFee: shippingFee,
          expectedDeliveryDay: expectedDeliveryDay,
          voucherCode: voucherCode,
          items: items,
          customerNotes: customerNotes,
        );

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

@JsonSerializable(explicitToJson: true)
class CreateOrderItemModel extends CreateOrderItemEntity {
  @JsonKey(name: 'productId')
  @override
  final String productId;
  
  @JsonKey(name: 'variantId')
  @override
  final String? variantId;
  
  @JsonKey(name: 'quantity')
  @override
  final int quantity;

  const CreateOrderItemModel({
    required this.productId,
    this.variantId,
    required this.quantity,
  }) : super(
          productId: productId,
          variantId: variantId,
          quantity: quantity,
        );

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