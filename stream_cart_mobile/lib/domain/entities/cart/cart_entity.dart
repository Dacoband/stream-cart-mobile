import 'package:equatable/equatable.dart';

class PriceDataEntity extends Equatable {
  final double currentPrice;
  final double originalPrice;
  final double discount;

  const PriceDataEntity({
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
  });

  factory PriceDataEntity.fromJson(Map<String, dynamic> json) {
    return PriceDataEntity(
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPrice': currentPrice,
      'originalPrice': originalPrice,
      'discount': discount,
    };
  }

  @override
  List<Object?> get props => [currentPrice, originalPrice, discount];
}

class CartItemEntity extends Equatable {
  final String cartItemId;
  final String productId;
  final String? variantId; 
  final String productName;
  final PriceDataEntity priceData;
  final int quantity;
  final String primaryImage;
  final Map<String, dynamic>? attributes;
  final int stockQuantity;
  final bool productStatus;
  final double weight;
  final double length;
  final double width;
  final double height;

  const CartItemEntity({
    required this.cartItemId,
    required this.productId,
    this.variantId,
    required this.productName,
    required this.priceData,
    required this.quantity,
    required this.primaryImage,
    this.attributes,
    required this.stockQuantity,
    required this.productStatus,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
  });

  // Getter để compatibility với code cũ
  double get currentPrice => priceData.currentPrice;
  double get originalPrice => priceData.originalPrice;
  double get discount => priceData.discount;

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      cartItemId: json['cartItemId'] ?? '',
      productId: json['productId'] ?? '',
      variantId: json['variantID'], // API uses 'variantID'
      productName: json['productName'] ?? '',
      priceData: PriceDataEntity.fromJson(json['priceData'] ?? {}),
      quantity: json['quantity'] ?? 0,
      primaryImage: json['primaryImage'] ?? '',
      attributes: json['attributes'],
      stockQuantity: json['stockQuantity'] ?? 0,
      productStatus: json['productStatus'] ?? false,
      weight: (json['weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'variantID': variantId,
      'productName': productName,
      'priceData': priceData.toJson(),
      'quantity': quantity,
      'primaryImage': primaryImage,
      'attributes': attributes,
      'stockQuantity': stockQuantity,
      'productStatus': productStatus,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
    };
  }

  CartItemEntity copyWith({
    String? cartItemId,
    String? productId,
    String? variantId,
    String? productName,
    PriceDataEntity? priceData,
    int? quantity,
    String? primaryImage,
    Map<String, dynamic>? attributes,
    int? stockQuantity,
    bool? productStatus,
    double? weight,
    double? length,
    double? width,
    double? height,
  }) {
    return CartItemEntity(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      priceData: priceData ?? this.priceData,
      quantity: quantity ?? this.quantity,
      primaryImage: primaryImage ?? this.primaryImage,
      attributes: attributes ?? this.attributes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      productStatus: productStatus ?? this.productStatus,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [
    cartItemId, 
    productId, 
    variantId, 
    productName, 
    priceData,
    quantity, 
    primaryImage, 
    attributes, 
    stockQuantity, 
    productStatus,
    weight,
    length,
    width,
    height,
  ];
}

class CartShopEntity extends Equatable {
  final String shopId;
  final String shopName;
  final List<CartItemEntity> products;
  final int numberOfProduct;
  final double totalPriceInShop;

  const CartShopEntity({
    required this.shopId,
    required this.shopName,
    required this.products,
    required this.numberOfProduct,
    required this.totalPriceInShop,
  });

  factory CartShopEntity.fromJson(Map<String, dynamic> json) {
    return CartShopEntity(
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => CartItemEntity.fromJson(item))
          .toList() ?? [],
      numberOfProduct: json['numberOfProduct'] ?? 0,
      totalPriceInShop: (json['totalPriceInShop'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'products': products.map((item) => item.toJson()).toList(),
      'numberOfProduct': numberOfProduct,
      'totalPriceInShop': totalPriceInShop,
    };
  }

  @override
  List<Object?> get props => [shopId, shopName, products, numberOfProduct, totalPriceInShop];
}

// Updated CartDataEntity - match với API response data
class CartDataEntity extends Equatable {
  final String cartId;
  final String customerId;
  final int totalProduct;
  final List<CartShopEntity> cartItemByShop;

  const CartDataEntity({
    required this.cartId,
    required this.customerId,
    required this.totalProduct,
    required this.cartItemByShop,
  });

  factory CartDataEntity.fromJson(Map<String, dynamic> json) {
    return CartDataEntity(
      cartId: json['cartId'] ?? '',
      customerId: json['customerId'] ?? '',
      totalProduct: json['totalProduct'] ?? 0,
      cartItemByShop: (json['cartItemByShop'] as List<dynamic>?)
          ?.map((shop) => CartShopEntity.fromJson(shop))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'customerId': customerId,
      'totalProduct': totalProduct,
      'cartItemByShop': cartItemByShop.map((shop) => shop.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [cartId, customerId, totalProduct, cartItemByShop];
}

class CartResponseEntity extends Equatable {
  final bool success;
  final String message;
  final CartDataEntity? data; 
  final List<String> errors;

  const CartResponseEntity({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory CartResponseEntity.fromJson(Map<String, dynamic> json) {
    return CartResponseEntity(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CartDataEntity.fromJson(json['data']) : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((error) => error.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors];
}

@Deprecated('Use CartDataEntity instead')
class CartSummaryEntity extends Equatable {
  final int totalItem;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final List<CartShopEntity> listCartItem;

  const CartSummaryEntity({
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.listCartItem,
  });

  @override
  List<Object?> get props => [totalItem, subTotal, discount, totalAmount, listCartItem];
}
@Deprecated('Use CartDataEntity instead')
class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, items, totalAmount, createdAt, updatedAt];
}



// Preview Order Data Entity 
class PreviewOrderDataEntity extends Equatable {
  final int totalItem;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final double length;
  final double width;
  final double height;
  final List<CartShopEntity> listCartItem; 

  const PreviewOrderDataEntity({
    required this.totalItem,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.length,
    required this.width,
    required this.height,
    required this.listCartItem,
  });

  factory PreviewOrderDataEntity.fromJson(Map<String, dynamic> json) {
    return PreviewOrderDataEntity(
      totalItem: json['totalItem'] ?? 0,
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      listCartItem: (json['listCartItem'] as List<dynamic>?)
          ?.map((shop) => CartShopEntity.fromJson(shop))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItem': totalItem,
      'subTotal': subTotal,
      'discount': discount,
      'totalAmount': totalAmount,
      'length': length,
      'width': width,
      'height': height,
      'listCartItem': listCartItem.map((shop) => shop.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    totalItem,
    subTotal,
    discount,
    totalAmount,
    length,
    width,
    height,
    listCartItem,
  ];
}

class PreviewOrderResponseEntity extends Equatable {
  final bool success;
  final String message;
  final PreviewOrderDataEntity? data;
  final List<String> errors;

  const PreviewOrderResponseEntity({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory PreviewOrderResponseEntity.fromJson(Map<String, dynamic> json) {
    return PreviewOrderResponseEntity(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PreviewOrderDataEntity.fromJson(json['data']) : null,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((error) => error.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors];
}

class CheckoutDataEntity extends Equatable {
  final PreviewOrderDataEntity orderPreview;
  final String? selectedAddressId;
  final String? selectedPaymentMethod;
  final String? customerNotes;
  final DateTime? expectedDeliveryDate;

  const CheckoutDataEntity({
    required this.orderPreview,
    this.selectedAddressId,
    this.selectedPaymentMethod,
    this.customerNotes,
    this.expectedDeliveryDate,
  });

  CheckoutDataEntity copyWith({
    PreviewOrderDataEntity? orderPreview,
    String? selectedAddressId,
    String? selectedPaymentMethod,
    String? customerNotes,
    DateTime? expectedDeliveryDate,
  }) {
    return CheckoutDataEntity(
      orderPreview: orderPreview ?? this.orderPreview,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      customerNotes: customerNotes ?? this.customerNotes,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
    );
  }

  @override
  List<Object?> get props => [
    orderPreview,
    selectedAddressId,
    selectedPaymentMethod,
    customerNotes,
    expectedDeliveryDate,
  ];
}

class CreateOrderFromCheckoutEntity extends Equatable {
  final List<String> selectedCartItemIds;
  final String deliveryAddressId;
  final String paymentMethod;
  final String? customerNotes;
  final DateTime? expectedDeliveryDate;

  const CreateOrderFromCheckoutEntity({
    required this.selectedCartItemIds,
    required this.deliveryAddressId,
    required this.paymentMethod,
    this.customerNotes,
    this.expectedDeliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedCartItemIds': selectedCartItemIds,
      'deliveryAddressId': deliveryAddressId,
      'paymentMethod': paymentMethod,
      'customerNotes': customerNotes,
      'expectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    selectedCartItemIds,
    deliveryAddressId,
    paymentMethod,
    customerNotes,
    expectedDeliveryDate,
  ];
}
