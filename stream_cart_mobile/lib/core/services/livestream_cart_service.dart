import 'dart:async';
import '../../data/models/cart_live/preview_order_live_model.dart';
import '../../data/models/cart_live/cart_product_live_model.dart';
import '../../data/models/cart_live/cart_item_by_shop_live_model.dart';
import '../../data/models/cart_live/price_data_live_model.dart';
import 'signalr_service.dart';

typedef CartLoadedCallback = void Function(PreviewOrderLiveModel cart);
typedef CartUpdatedCallback = void Function(String action, PreviewOrderLiveModel cart, Map<String, dynamic> raw);
typedef CartClearedCallback = void Function(Map<String, dynamic> payload);
typedef CartErrorCallback = void Function(String message);

class LivestreamCartService {
  final SignalRService signalRService;
  LivestreamCartService(this.signalRService);

  final Set<CartLoadedCallback> _onLoadedCbs = {};
  final Set<CartUpdatedCallback> _onUpdatedCbs = {};
  final Set<CartClearedCallback> _onClearedCbs = {};
  final Set<CartErrorCallback> _onErrorCbs = {};

  bool _handlersBound = false;

  Future<void> _bindHandlers() async {
    if (_handlersBound) return;
    await signalRService.connect();
  final conn = signalRService.connection;
    conn.off('LivestreamCartLoaded');
    conn.off('LivestreamCartUpdated');
    conn.off('LivestreamCartCleared');
    conn.off('Error');

    conn.on('LivestreamCartLoaded', (payload) {
      final data = _extractPayloadMap(payload);
      final cart = _mapCart(data['cart'] ?? data['Cart'] ?? {});
      for (final cb in _onLoadedCbs) cb(cart);
    });
    conn.on('LivestreamCartUpdated', (payload) {
      final data = _extractPayloadMap(payload);
      final cart = _mapCart(data['cart'] ?? data['Cart'] ?? {});
      final action = data['action'] ?? data['Action'] ?? 'ITEM_UPDATED';
      for (final cb in _onUpdatedCbs) cb(action, cart, data);
    });
    conn.on('LivestreamCartCleared', (payload) {
      final data = _extractPayloadMap(payload);
      for (final cb in _onClearedCbs) cb(data);
    });
    conn.on('Error', (msg) {
      final text = msg is String ? msg : msg.toString();
      for (final cb in _onErrorCbs) cb(text.toString());
    });
  _handlersBound = true;
  }

  Map<String, dynamic> _extractPayloadMap(dynamic payload) {
    if (payload is Map<String, dynamic>) return payload;
    if (payload is List && payload.isNotEmpty && payload[0] is Map<String, dynamic>) {
      return payload[0] as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

    Future<void> removeItem(String cartItemId) async {
    await signalRService.connect();
    final conn = signalRService.connection;
    await conn.invoke('RemoveFromLivestreamCart', args: [cartItemId]);
  }

  Future<void> clearCart(String livestreamId) async {
    await signalRService.connect();
    final conn = signalRService.connection;
    await conn.invoke('ClearLivestreamCart', args: [livestreamId]);
  }

  Future<void> ensureReady(String? livestreamId) async {
    await signalRService.connect();
    if (livestreamId != null && livestreamId.isNotEmpty) {
      await signalRService.joinLivestreamChat(livestreamId);
    }
    await _bindHandlers();
  }

  void onLoaded(CartLoadedCallback cb) => _onLoadedCbs.add(cb);
  void onUpdated(CartUpdatedCallback cb) => _onUpdatedCbs.add(cb);
  void onCleared(CartClearedCallback cb) => _onClearedCbs.add(cb);
  void onError(CartErrorCallback cb) => _onErrorCbs.add(cb);

  Future<void> loadCart(String livestreamId) async {
    await ensureReady(livestreamId);
  final conn = signalRService.connection;
    await conn.invoke('GetLivestreamCart', args: [livestreamId]);
  }

  Future<void> addToCart(String livestreamId, String livestreamProductId, int quantity) async {
    await ensureReady(livestreamId);
  final conn = signalRService.connection;
    await conn.invoke('AddToLivestreamCart', args: [livestreamId, livestreamProductId, quantity]);
  }

  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    await ensureReady(null);
  final conn = signalRService.connection;
    await conn.invoke('UpdateLivestreamCartItemQuantity', args: [cartItemId, newQuantity]);
  }
  PreviewOrderLiveModel _mapCart(Map<String, dynamic> server) {
    final items = (server['items'] ?? server['Items'] ?? []) as List<dynamic>;
    final listCartItem = <CartItemByShopLiveModel>[];
    if (items.isNotEmpty) {
      listCartItem.add(CartItemByShopLiveModel(
        shopId: items.first['shopId'] ?? '',
        shopName: items.first['shopName'] ?? '',
        products: items.map((x) => _mapProduct(x as Map<String, dynamic>)).toList(),
      ));
    }
    return PreviewOrderLiveModel(
      livestreamId: server['livestreamId'] ?? server['LivestreamId'] ?? '',
      totalItem: server['totalItems'] ?? server['TotalItems'] ?? 0,
      subTotal: (server['subTotal'] ?? server['SubTotal'] ?? 0).toDouble(),
      discount: (server['totalDiscount'] ?? server['TotalDiscount'] ?? 0).toDouble(),
      totalAmount: (server['totalAmount'] ?? server['TotalAmount'] ?? 0).toDouble(),
      listCartItem: listCartItem,
    );
  }

  CartProductLiveModel _mapProduct(Map<String, dynamic> server) {
    return CartProductLiveModel(
      cartItemId: server['id'] ?? server['Id'] ?? '',
      productId: server['productId'] ?? server['ProductId'] ?? '',
      variantID: server['variantId'] ?? server['VariantId'] ?? '',
      productName: server['productName'] ?? server['ProductName'] ?? '',
      priceData: PriceDataLiveModel(
        currentPrice: (server['livestreamPrice'] ?? server['LivestreamPrice'] ?? 0).toDouble(),
        originalPrice: (server['originalPrice'] ?? server['OriginalPrice'] ?? 0).toDouble(),
        discount: (server['discountPercentage'] ?? server['DiscountPercentage'] ?? 0).toDouble(),
      ),
      quantity: server['quantity'] ?? server['Quantity'] ?? 0,
      primaryImage: server['primaryImage'] ?? server['PrimaryImage'] ?? '',
      attributes: {},
      stockQuantity: server['stock'] ?? server['Stock'] ?? 0,
      productStatus: server['productStatus'] ?? server['ProductStatus'] ?? true,
      length: (server['length'] ?? 0).toDouble(),
      width: (server['width'] ?? 0).toDouble(),
      height: (server['height'] ?? 0).toDouble(),
      weight: (server['weight'] ?? 0).toDouble(),
    );
  }
}
