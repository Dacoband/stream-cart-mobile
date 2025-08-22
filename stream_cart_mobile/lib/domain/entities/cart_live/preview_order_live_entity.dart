import 'package:equatable/equatable.dart';
import 'cart_item_by_shop_live_entity.dart';

class PreviewOrderLiveEntity extends Equatable {
  final String livestreamId;
  final int totalItem;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final List<CartItemByShopLiveEntity> listCartItem;

  const PreviewOrderLiveEntity({
    required this.livestreamId,
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.listCartItem,
  });

  PreviewOrderLiveEntity copyWith({
    String? livestreamId,
    int? totalItem,
    double? subTotal,
    double? discount,
    double? totalAmount,
    List<CartItemByShopLiveEntity>? listCartItem,
  }) {
    return PreviewOrderLiveEntity(
      livestreamId: livestreamId ?? this.livestreamId,
      totalItem: totalItem ?? this.totalItem,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      listCartItem: listCartItem ?? this.listCartItem,
    );
  }

  @override
  List<Object?> get props => [livestreamId, totalItem, subTotal, discount, totalAmount, listCartItem];

  @override
  String toString() => 'PreviewOrderLiveEntity(livestreamId: $livestreamId, totalItem: $totalItem, subTotal: $subTotal, discount: $discount, totalAmount: $totalAmount, listCartItem: $listCartItem)';
}
