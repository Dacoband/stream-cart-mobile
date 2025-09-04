import '../../../core/services/livestream_cart_service.dart';
import '../../../data/models/cart_live/preview_order_live_model.dart';

class ListenLivestreamCartEventsUsecase {
  final LivestreamCartService cartService;
  
  // Store current callbacks for cleanup
  void Function(PreviewOrderLiveModel cart)? _currentOnLoaded;
  void Function(String action, PreviewOrderLiveModel cart, Map<String, dynamic> raw)? _currentOnUpdated;
  void Function(Map<String, dynamic> payload)? _currentOnCleared;
  void Function(String message)? _currentOnError;
  
  ListenLivestreamCartEventsUsecase(this.cartService);

  void listen({
    void Function(PreviewOrderLiveModel cart)? onLoaded,
    void Function(String action, PreviewOrderLiveModel cart, Map<String, dynamic> raw)? onUpdated,
    void Function(Map<String, dynamic> payload)? onCleared,
    void Function(String message)? onError,
  }) {
    // Clean up previous callbacks first
    cleanup();
    
    // Store new callbacks
    _currentOnLoaded = onLoaded;
    _currentOnUpdated = onUpdated;
    _currentOnCleared = onCleared;
    _currentOnError = onError;
    
    // Register new callbacks
    if (onLoaded != null) cartService.onLoaded(onLoaded);
    if (onUpdated != null) cartService.onUpdated(onUpdated);
    if (onCleared != null) cartService.onCleared(onCleared);
    if (onError != null) cartService.onError(onError);
  }

  void cleanup() {
    // Remove current callbacks from service
    if (_currentOnLoaded != null) cartService.removeLoadedCallback(_currentOnLoaded!);
    if (_currentOnUpdated != null) cartService.removeUpdatedCallback(_currentOnUpdated!);
    if (_currentOnCleared != null) cartService.removeClearedCallback(_currentOnCleared!);
    if (_currentOnError != null) cartService.removeErrorCallback(_currentOnError!);
    
    // Clear references
    _currentOnLoaded = null;
    _currentOnUpdated = null;
    _currentOnCleared = null;
    _currentOnError = null;
  }
}
