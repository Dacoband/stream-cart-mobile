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
    
    try {
      await signalRService.connect();
      final conn = signalRService.connection;
      
      // Clear existing handlers
      conn.off('LivestreamCartLoaded');
      conn.off('LivestreamCartUpdated');
      conn.off('LivestreamCartCleared');
      conn.off('Error');

      conn.on('LivestreamCartLoaded', (payload) {
        try {
          final data = _extractPayloadMap(payload);
          final cart = _mapCart(data['cart'] ?? data['Cart'] ?? {});
          
          // Create a copy of callbacks to avoid concurrent modification
          final loadedCallbacks = List<CartLoadedCallback>.from(_onLoadedCbs);
          for (final cb in loadedCallbacks) {
            try {
              cb(cart);
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        } catch (e) {
          final errorCallbacks = List<CartErrorCallback>.from(_onErrorCbs);
          for (final cb in errorCallbacks) {
            try {
              cb('Failed to load cart: $e');
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        }
      });
      
      conn.on('LivestreamCartUpdated', (payload) {
        try {
          final data = _extractPayloadMap(payload);
          final cart = _mapCart(data['cart'] ?? data['Cart'] ?? {});
          final action = data['action'] ?? data['Action'] ?? 'ITEM_UPDATED';
          
          // Create a copy of callbacks to avoid concurrent modification
          final updatedCallbacks = List<CartUpdatedCallback>.from(_onUpdatedCbs);
          for (final cb in updatedCallbacks) {
            try {
              cb(action, cart, data);
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        } catch (e) {
          final errorCallbacks = List<CartErrorCallback>.from(_onErrorCbs);
          for (final cb in errorCallbacks) {
            try {
              cb('Failed to update cart: $e');
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        }
      });
      
      conn.on('LivestreamCartCleared', (payload) {
        try {
          final data = _extractPayloadMap(payload);
          
          // Create a copy of callbacks to avoid concurrent modification
          final clearedCallbacks = List<CartClearedCallback>.from(_onClearedCbs);
          for (final cb in clearedCallbacks) {
            try {
              cb(data);
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        } catch (e) {
          final errorCallbacks = List<CartErrorCallback>.from(_onErrorCbs);
          for (final cb in errorCallbacks) {
            try {
              cb('Failed to clear cart: $e');
            } catch (e) {
              // Ignore callback errors (BLoC might be closed)
            }
          }
        }
      });
      
      conn.on('Error', (msg) {
        final text = msg?.toString() ?? 'Unknown error';
        final errorCallbacks = List<CartErrorCallback>.from(_onErrorCbs);
        for (final cb in errorCallbacks) {
          try {
            cb(text);
          } catch (e) {
            // Ignore callback errors (BLoC might be closed)
          }
        }
      });
      
      _handlersBound = true;
    } catch (e) {
      for (final cb in _onErrorCbs) cb('Failed to setup cart service: $e');
    }
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
    await conn.invoke('DeleteLivestreamCartItem', args: [cartItemId]);
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

  // Methods to remove callbacks (for cleanup)
  void removeLoadedCallback(CartLoadedCallback cb) => _onLoadedCbs.remove(cb);
  void removeUpdatedCallback(CartUpdatedCallback cb) => _onUpdatedCbs.remove(cb);
  void removeClearedCallback(CartClearedCallback cb) => _onClearedCbs.remove(cb);
  void removeErrorCallback(CartErrorCallback cb) => _onErrorCbs.remove(cb);

  // Clear all callbacks (useful when BLoC is disposed)
  void clearAllCallbacks() {
    _onLoadedCbs.clear();
    _onUpdatedCbs.clear();
    _onClearedCbs.clear();
    _onErrorCbs.clear();
  }

  Future<void> loadCart(String livestreamId) async {
    try {
      await ensureReady(livestreamId);
      final conn = signalRService.connection;
      
      await conn.invoke('GetLivestreamCart', args: [livestreamId]);
      
      // Add a small delay to allow SignalR response to come back
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      for (final cb in _onErrorCbs) cb('Failed to load cart: $e');
      rethrow;
    }
  }

  /// Retry loading cart with exponential backoff
  Future<void> loadCartWithRetry(String livestreamId, {int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await loadCart(livestreamId);
        return; // Success, exit retry loop
      } catch (e) {
        if (attempt == maxRetries) {
          rethrow; // Final attempt failed, rethrow error
        }
        
        // Wait before retry with exponential backoff
        final delay = Duration(milliseconds: 1000 * attempt);
        await Future.delayed(delay);
      }
    }
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
    try {
      final items = (server['items'] ?? server['Items'] ?? []) as List<dynamic>;
      
      final listCartItem = <CartItemByShopLiveModel>[];
      if (items.isNotEmpty) {
        final firstItem = items.first;
        
        listCartItem.add(CartItemByShopLiveModel(
          shopId: firstItem['shopId'] ?? '',
          shopName: firstItem['shopName'] ?? '',
          products: items.map((x) => _mapProduct(x as Map<String, dynamic>)).toList(),
        ));
      }
      
      final cart = PreviewOrderLiveModel(
        livestreamId: server['livestreamId'] ?? server['LivestreamId'] ?? '',
        totalItem: server['totalItems'] ?? server['TotalItems'] ?? 0,
        subTotal: (server['subTotal'] ?? server['SubTotal'] ?? 0).toDouble(),
        discount: (server['totalDiscount'] ?? server['TotalDiscount'] ?? 0).toDouble(),
        totalAmount: (server['totalAmount'] ?? server['TotalAmount'] ?? 0).toDouble(),
        listCartItem: listCartItem,
      );
      
      return cart;
    } catch (e) {
      // Return empty cart on error
      return PreviewOrderLiveModel(
        livestreamId: server['livestreamId'] ?? server['LivestreamId'] ?? '',
        totalItem: 0,
        subTotal: 0.0,
        discount: 0.0,
        totalAmount: 0.0,
        listCartItem: [],
      );
    }
  }

  CartProductLiveModel _mapProduct(Map<String, dynamic> server) {
    try {
      final product = CartProductLiveModel(
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
      
      return product;
    } catch (e) {
      rethrow;
    }
  }
}
