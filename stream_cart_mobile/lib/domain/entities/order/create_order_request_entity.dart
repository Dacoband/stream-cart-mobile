import 'package:equatable/equatable.dart';

class CreateOrderRequestEntity extends Equatable {
  final String paymentMethod;
  final String addressId;
  final String? livestreamId;
  final String? createdFromCommentId;
  final List<OrderByShopEntity> ordersByShop;

  const CreateOrderRequestEntity({
    required this.paymentMethod,
    required this.addressId,
    this.livestreamId,
    this.createdFromCommentId,
    required this.ordersByShop,
  });

  CreateOrderRequestEntity copyWith({
    String? paymentMethod,
    String? addressId,
    String? livestreamId,
    String? createdFromCommentId,
    List<OrderByShopEntity>? ordersByShop,
  }) {
    return CreateOrderRequestEntity(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addressId: addressId ?? this.addressId,
      livestreamId: livestreamId ?? this.livestreamId,
      createdFromCommentId: createdFromCommentId ?? this.createdFromCommentId,
      ordersByShop: ordersByShop ?? this.ordersByShop,
    );
  }

  @override
  List<Object?> get props => [
        paymentMethod,
        addressId,
        livestreamId,
        createdFromCommentId,
        ordersByShop,
      ];

  @override
  String toString() {
    return 'CreateOrderRequestEntity(paymentMethod: $paymentMethod, addressId: $addressId, livestreamId: $livestreamId, createdFromCommentId: $createdFromCommentId, ordersByShop: $ordersByShop)';
  }
}

class OrderByShopEntity extends Equatable {
  final String shopId;
  final String? shippingProviderId;
  final double shippingFee;
  final String? expectedDeliveryDay;
  final String? voucherCode;
  final List<CreateOrderItemEntity> items;
  final String? customerNotes;

  const OrderByShopEntity({
    required this.shopId,
    this.shippingProviderId,
    required this.shippingFee,
    this.expectedDeliveryDay,
    this.voucherCode,
    required this.items,
    this.customerNotes,
  });

  OrderByShopEntity copyWith({
    String? shopId,
    String? shippingProviderId,
    double? shippingFee,
    String? expectedDeliveryDay,
    String? voucherCode,
    List<CreateOrderItemEntity>? items,
    String? customerNotes,
  }) {
    return OrderByShopEntity(
      shopId: shopId ?? this.shopId,
      shippingProviderId: shippingProviderId ?? this.shippingProviderId,
      shippingFee: shippingFee ?? this.shippingFee,
      expectedDeliveryDay: expectedDeliveryDay ?? this.expectedDeliveryDay,
      voucherCode: voucherCode ?? this.voucherCode,
      items: items ?? this.items,
      customerNotes: customerNotes ?? this.customerNotes,
    );
  }

  @override
  List<Object?> get props => [
        shopId,
        shippingProviderId,
        shippingFee,
        expectedDeliveryDay,
        voucherCode,
        items,
        customerNotes,
      ];

  @override
  String toString() {
    return 'OrderByShopEntity(shopId: $shopId, shippingProviderId: $shippingProviderId, shippingFee: $shippingFee, expectedDeliveryDay: $expectedDeliveryDay, voucherCode: $voucherCode, items: $items, customerNotes: $customerNotes)';
  }
}

class CreateOrderItemEntity extends Equatable {
  final String productId;
  final String? variantId;
  final int quantity;

  const CreateOrderItemEntity({
    required this.productId,
    this.variantId,
    required this.quantity,
  });

  CreateOrderItemEntity copyWith({
    String? productId,
    String? variantId,
    int? quantity,
  }) {
    return CreateOrderItemEntity(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, variantId, quantity];

  @override
  String toString() {
    return 'CreateOrderItemEntity(productId: $productId, variantId: $variantId, quantity: $quantity)';
  }
}