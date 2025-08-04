import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/entities/order/order_item_entity.dart';
import '../../../domain/entities/order/shipping_address_entity.dart';
import 'order_item_model.dart';
import 'shipping_address_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends OrderEntity {
  @JsonKey(
    fromJson: _shippingAddressFromJson,
    toJson: _shippingAddressToJson,
  )
  @override
  final ShippingAddressModel shippingAddress;

  @JsonKey(
    fromJson: _itemsFromJson,
    toJson: _itemsToJson,
  )
  @override
  final List<OrderItemModel> items;

  const OrderModel({
    required super.id,
    required super.orderCode,
    required super.orderDate,
    required super.orderStatus,
    required super.paymentStatus,
    required super.totalPrice,
    required super.shippingFee,
    required super.discountAmount,
    required super.finalAmount,
    super.customerNotes,
    super.estimatedDeliveryDate,
    super.actualDeliveryDate,
    super.trackingCode,
    required this.shippingAddress,
    required super.accountId,
    required super.shopId,
    super.shippingProviderId,
    super.livestreamId,
    super.voucherCode,
    required this.items,
  }) : super(
          shippingAddress: shippingAddress,
          items: items,
        );

  // Static methods for JSON conversion
  static ShippingAddressModel _shippingAddressFromJson(Map<String, dynamic> json) =>
      ShippingAddressModel.fromJson(json);

  static Map<String, dynamic> _shippingAddressToJson(ShippingAddressEntity shippingAddress) =>
      (shippingAddress as ShippingAddressModel).toJson();

  static List<OrderItemModel> _itemsFromJson(List<dynamic> json) =>
      json.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _itemsToJson(List<OrderItemEntity> items) =>
      items.map((item) => (item as OrderItemModel).toJson()).toList();

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderCode: orderCode,
      orderDate: orderDate,
      orderStatus: orderStatus,
      paymentStatus: paymentStatus,
      totalPrice: totalPrice,
      shippingFee: shippingFee,
      discountAmount: discountAmount,
      finalAmount: finalAmount,
      customerNotes: customerNotes,
      estimatedDeliveryDate: estimatedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate,
      trackingCode: trackingCode,
      shippingAddress: shippingAddress.toEntity(),
      accountId: accountId,
      shopId: shopId,
      shippingProviderId: shippingProviderId,
      livestreamId: livestreamId,
      voucherCode: voucherCode,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderCode: entity.orderCode,
      orderDate: entity.orderDate,
      orderStatus: entity.orderStatus,
      paymentStatus: entity.paymentStatus,
      totalPrice: entity.totalPrice,
      shippingFee: entity.shippingFee,
      discountAmount: entity.discountAmount,
      finalAmount: entity.finalAmount,
      customerNotes: entity.customerNotes,
      estimatedDeliveryDate: entity.estimatedDeliveryDate,
      actualDeliveryDate: entity.actualDeliveryDate,
      trackingCode: entity.trackingCode,
      shippingAddress: ShippingAddressModel.fromEntity(entity.shippingAddress),
      accountId: entity.accountId,
      shopId: entity.shopId,
      shippingProviderId: entity.shippingProviderId,
      livestreamId: entity.livestreamId,
      voucherCode: entity.voucherCode,
      items: entity.items.map((item) => OrderItemModel.fromEntity(item)).toList(),
    );
  }

  @override
  OrderModel copyWith({
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
    return OrderModel(
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
      shippingAddress: shippingAddress != null 
          ? (shippingAddress is ShippingAddressModel 
              ? shippingAddress 
              : ShippingAddressModel.fromEntity(shippingAddress))
          : this.shippingAddress,
      accountId: accountId ?? this.accountId,
      shopId: shopId ?? this.shopId,
      shippingProviderId: shippingProviderId ?? this.shippingProviderId,
      livestreamId: livestreamId ?? this.livestreamId,
      voucherCode: voucherCode ?? this.voucherCode,
      items: items != null 
          ? items.map((item) => item is OrderItemModel 
              ? item 
              : OrderItemModel.fromEntity(item)).toList()
          : this.items,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && super == other;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'OrderModel(${super.toString()})';
  }
}