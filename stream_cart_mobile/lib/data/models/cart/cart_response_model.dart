import 'package:json_annotation/json_annotation.dart';
import 'cart_model.dart';
import '../../../domain/entities/cart/cart_entity.dart';

part 'cart_response_model.g.dart';

// ===== GET CART API MODELS =====

@JsonSerializable()
class GetCartResponseDataModel {
  @JsonKey(name: 'cartId')
  final String cartId;
  
  @JsonKey(name: 'customerId')
  final String customerId;
  
  @JsonKey(name: 'totalProduct')
  final int totalProduct;
  
  @JsonKey(name: 'cartItemByShop')
  final List<CartShopModel> cartItemByShop;

  const GetCartResponseDataModel({
    required this.cartId,
    required this.customerId,
    required this.totalProduct,
    required this.cartItemByShop,
  });

  factory GetCartResponseDataModel.fromJson(Map<String, dynamic> json) => _$GetCartResponseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetCartResponseDataModelToJson(this);

  CartDataEntity toEntity() {
    return CartDataEntity(
      cartId: cartId,
      customerId: customerId,
      totalProduct: totalProduct,
      cartItemByShop: cartItemByShop.map((shop) => shop.toEntity()).toList(),
    );
  }

  factory GetCartResponseDataModel.fromEntity(CartDataEntity entity) {
    return GetCartResponseDataModel(
      cartId: entity.cartId,
      customerId: entity.customerId,
      totalProduct: entity.totalProduct,
      cartItemByShop: entity.cartItemByShop.map((shop) => CartShopModel.fromEntity(shop)).toList(),
    );
  }
}

@JsonSerializable()
class GetCartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final GetCartResponseDataModel? data;
  
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

  CartResponseEntity toEntity() {
    return CartResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
      errors: errors,
    );
  }

  factory GetCartResponseModel.fromEntity(CartResponseEntity entity) {
    return GetCartResponseModel(
      success: entity.success,
      message: entity.message,
      data: entity.data != null ? GetCartResponseDataModel.fromEntity(entity.data!) : null,
      errors: entity.errors,
    );
  }
}

// ===== PREVIEW ORDER API MODELS =====

@JsonSerializable()
class PreviewOrderDataModel {
  @JsonKey(name: 'totalItem')
  final int totalItem;
  
  @JsonKey(name: 'subTotal')
  final double subTotal;
  
  @JsonKey(name: 'discount')
  final double discount;
  
  @JsonKey(name: 'totalAmount')
  final double totalAmount;
  
  @JsonKey(name: 'length')
  final double length;
  
  @JsonKey(name: 'width')
  final double width;
  
  @JsonKey(name: 'height')
  final double height;
  
  @JsonKey(name: 'listCartItem')
  final List<CartShopModel> listCartItem;

  const PreviewOrderDataModel({
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.length,
    required this.width,
    required this.height,
    required this.listCartItem,
  });

  factory PreviewOrderDataModel.fromJson(Map<String, dynamic> json) => _$PreviewOrderDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreviewOrderDataModelToJson(this);

  PreviewOrderDataEntity toEntity() {
    return PreviewOrderDataEntity(
      totalItem: totalItem,
      subTotal: subTotal,
      discount: discount,
      totalAmount: totalAmount,
      length: length,
      width: width,
      height: height,
      listCartItem: listCartItem.map((shop) => shop.toEntity()).toList(),
    );
  }

  factory PreviewOrderDataModel.fromEntity(PreviewOrderDataEntity entity) {
    return PreviewOrderDataModel(
      totalItem: entity.totalItem,
      subTotal: entity.subTotal,
      discount: entity.discount,
      totalAmount: entity.totalAmount,
      length: entity.length,
      width: entity.width,
      height: entity.height,
      listCartItem: entity.listCartItem.map((shop) => CartShopModel.fromEntity(shop)).toList(),
    );
  }
}

@JsonSerializable()
class PreviewOrderResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final PreviewOrderDataModel? data;
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const PreviewOrderResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory PreviewOrderResponseModel.fromJson(Map<String, dynamic> json) => _$PreviewOrderResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreviewOrderResponseModelToJson(this);

  PreviewOrderResponseEntity toEntity() {
    return PreviewOrderResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
      errors: errors,
    );
  }

  factory PreviewOrderResponseModel.fromEntity(PreviewOrderResponseEntity entity) {
    return PreviewOrderResponseModel(
      success: entity.success,
      message: entity.message,
      data: entity.data != null ? PreviewOrderDataModel.fromEntity(entity.data!) : null,
      errors: entity.errors,
    );
  }
}

// ===== ADD TO CART RESPONSE MODEL =====

@JsonSerializable()
class AddToCartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final dynamic data; // API trả về data khác nhau
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const AddToCartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) => _$AddToCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddToCartResponseModelToJson(this);
}

// ===== UPDATE CART RESPONSE MODEL =====

@JsonSerializable()
class UpdateCartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final CartUpdateResponseModel? data;
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const UpdateCartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory UpdateCartResponseModel.fromJson(Map<String, dynamic> json) => _$UpdateCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateCartResponseModelToJson(this);
}

// ===== DELETE CART RESPONSE MODEL =====

@JsonSerializable()
class DeleteCartResponseModel {
  @JsonKey(name: 'success')
  final bool success;
  
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'data')
  final dynamic data; // Thường null khi delete
  
  @JsonKey(name: 'errors')
  final List<String> errors;

  const DeleteCartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory DeleteCartResponseModel.fromJson(Map<String, dynamic> json) => _$DeleteCartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteCartResponseModelToJson(this);
}

// ===== GENERIC API RESPONSE (NON-SERIALIZABLE) =====

// Remove @JsonSerializable để tránh generic type issue
class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String> errors;

  const ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  // Manual JSON handling cho generic type
  static ApiResponseModel<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((error) => error.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
      'errors': errors,
    };
  }

  // Convenience methods for common types
  static ApiResponseModel<GetCartResponseDataModel> cartResponse(Map<String, dynamic> json) {
    return fromJson<GetCartResponseDataModel>(
      json,
      (data) => GetCartResponseDataModel.fromJson(data),
    );
  }

  static ApiResponseModel<PreviewOrderDataModel> previewOrderResponse(Map<String, dynamic> json) {
    return fromJson<PreviewOrderDataModel>(
      json,
      (data) => PreviewOrderDataModel.fromJson(data),
    );
  }
}

// ===== BACKWARDS COMPATIBILITY =====

@Deprecated('Use GetCartResponseDataModel instead')
typedef GetCartResponseData = GetCartResponseDataModel;

@Deprecated('Use specific response models instead')
@JsonSerializable()
class CartSummaryModel {
  @JsonKey(name: 'totalItem')
  final int totalItem;
  
  @JsonKey(name: 'subTotal')
  final double subTotal;
  
  @JsonKey(name: 'discount')
  final double discount;
  
  @JsonKey(name: 'totalAmount')
  final double totalAmount;
  
  @JsonKey(name: 'listCartItem')
  final List<CartShopModel> listCartItem;

  const CartSummaryModel({
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.listCartItem,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) => _$CartSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartSummaryModelToJson(this);

  // Convert từ GetCartResponseDataModel
  factory CartSummaryModel.fromGetCartResponse(GetCartResponseDataModel response) {
    double totalAmount = 0;
    for (var shop in response.cartItemByShop) {
      totalAmount += shop.totalPriceInShop;
    }
    
    return CartSummaryModel(
      totalItem: response.totalProduct,
      subTotal: totalAmount,
      discount: 0,
      totalAmount: totalAmount,
      listCartItem: response.cartItemByShop,
    );
  }

  // Convert từ PreviewOrderDataModel
  factory CartSummaryModel.fromPreviewOrder(PreviewOrderDataModel previewOrder) {
    return CartSummaryModel(
      totalItem: previewOrder.totalItem,
      subTotal: previewOrder.subTotal,
      discount: previewOrder.discount,
      totalAmount: previewOrder.totalAmount,
      listCartItem: previewOrder.listCartItem,
    );
  }

  CartSummaryEntity toEntity() {
    return CartSummaryEntity(
      totalItem: totalItem,
      subTotal: subTotal,
      discount: discount,
      totalAmount: totalAmount,
      listCartItem: listCartItem.map((shop) => shop.toEntity()).toList(),
    );
  }
}
