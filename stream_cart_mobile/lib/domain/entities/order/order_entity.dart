import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'shipping_address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String orderCode;
  final DateTime orderDate;
  final int orderStatus;
  final int paymentStatus;
  final double totalPrice;
  final double shippingFee;
  final double discountAmount;
  final double finalAmount;
  final String? customerNotes;
  final DateTime? estimatedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final String? trackingCode;
  final ShippingAddressEntity shippingAddress;
  final String accountId;
  final String shopId;
  final String? shippingProviderId;
  final String? livestreamId;
  final String? voucherCode;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.orderCode,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentStatus,
    required this.totalPrice,
    required this.shippingFee,
    required this.discountAmount,
    required this.finalAmount,
    this.customerNotes,
    this.estimatedDeliveryDate,
    this.actualDeliveryDate,
    this.trackingCode,
    required this.shippingAddress,
    required this.accountId,
    required this.shopId,
    this.shippingProviderId,
    this.livestreamId,
    this.voucherCode,
    required this.items,
  });

  OrderEntity copyWith({
    String? id,
    String? orderCode,
    DateTime? orderDate,
    int? orderStatus,
    int? paymentStatus,
    double? totalPrice,
    double? shippingFee,
    double? discountAmount,
    double? finalAmount,
    String? customerNotes,
    DateTime? estimatedDeliveryDate,
    DateTime? actualDeliveryDate,
    String? trackingCode,
    ShippingAddressEntity? shippingAddress,
    String? accountId,
    String? shopId,
    String? shippingProviderId,
    String? livestreamId,
    String? voucherCode,
    List<OrderItemEntity>? items,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      orderDate: orderDate ?? this.orderDate,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      shippingFee: shippingFee ?? this.shippingFee,
      discountAmount: discountAmount ?? this.discountAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      customerNotes: customerNotes ?? this.customerNotes,
      estimatedDeliveryDate: estimatedDeliveryDate ?? this.estimatedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate ?? this.actualDeliveryDate,
      trackingCode: trackingCode ?? this.trackingCode,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      accountId: accountId ?? this.accountId,
      shopId: shopId ?? this.shopId,
      shippingProviderId: shippingProviderId ?? this.shippingProviderId,
      livestreamId: livestreamId ?? this.livestreamId,
      voucherCode: voucherCode ?? this.voucherCode,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderCode,
        orderDate,
        orderStatus,
        paymentStatus,
        totalPrice,
        shippingFee,
        discountAmount,
        finalAmount,
        customerNotes,
        estimatedDeliveryDate,
        actualDeliveryDate,
        trackingCode,
        shippingAddress,
        accountId,
        shopId,
        shippingProviderId,
        livestreamId,
        voucherCode,
        items,
      ];

  @override
  String toString() {
    return 'OrderEntity(id: $id, orderCode: $orderCode, orderDate: $orderDate, orderStatus: $orderStatus, paymentStatus: $paymentStatus, totalPrice: $totalPrice, shippingFee: $shippingFee, discountAmount: $discountAmount, finalAmount: $finalAmount, customerNotes: $customerNotes, estimatedDeliveryDate: $estimatedDeliveryDate, actualDeliveryDate: $actualDeliveryDate, trackingCode: $trackingCode, shippingAddress: $shippingAddress, accountId: $accountId, shopId: $shopId, shippingProviderId: $shippingProviderId, livestreamId: $livestreamId, voucherCode: $voucherCode, items: $items)';
  }
}