import 'package:json_annotation/json_annotation.dart';
import 'cart_model.dart';

part 'cart_response_model.g.dart';

@JsonSerializable()
class GetCartResponseData {
  @JsonKey(name: 'cartId')
  final String cartId;
  
  @JsonKey(name: 'customerId')
  final String customerId;
  
  @JsonKey(name: 'totalProduct')
  final int totalProduct;
  
  @JsonKey(name: 'cartItemByShop')
  final List<CartShopModel> cartItemByShop;

  const GetCartResponseData({
    required this.cartId,
    required this.customerId,
    required this.totalProduct,
    required this.cartItemByShop,
  });

  factory GetCartResponseData.fromJson(Map<String, dynamic> json) => _$GetCartResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetCartResponseDataToJson(this);

  // Chuyển đổi sang CartSummaryModel nếu cần thiết
  CartSummaryModel toCartSummaryModel() {
    double totalAmount = 0;
    for (var shop in cartItemByShop) {
      totalAmount += shop.totalPriceInShop ?? 0;
    }
    
    return CartSummaryModel(
      totalItem: totalProduct,
      subTotal: totalAmount,
      discount: 0,
      totalAmount: totalAmount,
      listCartItem: cartItemByShop,
    );
  }
}

// Lớp này sẽ đại diện cho response từ API khi lấy thông tin giỏ hàng
@JsonSerializable()
class GetCartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final GetCartResponseData? data;
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const GetCartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) => _$GetCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetCartResponseModelToJson(this);
}
