import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/cart_live/preview_order_live_entity.dart';
import 'cart_item_by_shop_live_model.dart';

part 'preview_order_live_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviewOrderLiveModel {
  final String livestreamId;
  final int totalItem;
  final double subTotal;
  final double discount;
  final double totalAmount;
  @JsonKey(fromJson: _listCartItemFromJson, toJson: _listCartItemToJson)
  final List<CartItemByShopLiveModel> listCartItem;

  const PreviewOrderLiveModel({
    required this.livestreamId,
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.listCartItem,
  });

  factory PreviewOrderLiveModel.fromJson(Map<String, dynamic> json) => _$PreviewOrderLiveModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreviewOrderLiveModelToJson(this);

  static List<CartItemByShopLiveModel> _listCartItemFromJson(List<dynamic> json) =>
      json.map((e) => CartItemByShopLiveModel.fromJson(e as Map<String, dynamic>)).toList();
  static List<Map<String, dynamic>> _listCartItemToJson(List<CartItemByShopLiveModel> items) =>
      items.map((e) => e.toJson()).toList();

  PreviewOrderLiveEntity toEntity() => PreviewOrderLiveEntity(
    livestreamId: livestreamId,
    totalItem: totalItem,
    subTotal: subTotal,
    discount: discount,
    totalAmount: totalAmount,
    listCartItem: listCartItem.map((e) => e.toEntity()).toList(),
  );

  factory PreviewOrderLiveModel.fromEntity(PreviewOrderLiveEntity entity) {
    return PreviewOrderLiveModel(
      livestreamId: entity.livestreamId,
      totalItem: entity.totalItem,
      subTotal: entity.subTotal,
      discount: entity.discount,
      totalAmount: entity.totalAmount,
      listCartItem: entity.listCartItem.map((e) => CartItemByShopLiveModel.fromEntity(e)).toList(),
    );
  }

  PreviewOrderLiveModel copyWith({
    String? livestreamId,
    int? totalItem,
    double? subTotal,
    double? discount,
    double? totalAmount,
    List<CartItemByShopLiveModel>? listCartItem,
  }) {
    return PreviewOrderLiveModel(
      livestreamId: livestreamId ?? this.livestreamId,
      totalItem: totalItem ?? this.totalItem,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      listCartItem: listCartItem ?? this.listCartItem,
    );
  }
}
