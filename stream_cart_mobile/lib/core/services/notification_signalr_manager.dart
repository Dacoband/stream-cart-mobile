import 'dart:async';
import 'package:flutter/foundation.dart';
import '../di/dependency_injection.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/notification/notification_event.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_state.dart';
import '../services/storage_service.dart';

class NotificationSignalRManager {
  static NotificationSignalRManager? _instance;
  StreamSubscription<AuthState>? _authStateSubscription;
  bool _isInitialized = false;

  static NotificationSignalRManager get instance {
    _instance ??= NotificationSignalRManager._();
    return _instance!;
  }

  NotificationSignalRManager._();

  void initialize() {
    if (_isInitialized) return;
    
    _isInitialized = true;
    
    // Listen to auth state changes
    _authStateSubscription = getIt<AuthBloc>().stream.listen((authState) {
      _handleAuthStateChange(authState);
    });

    // Check current auth state
    final currentState = getIt<AuthBloc>().state;
    _handleAuthStateChange(currentState);
  }

  void _handleAuthStateChange(AuthState authState) async {
    if (authState is AuthSuccess) {
      await _connectSignalR();
    } else {
      await _disconnectSignalR();
    }
  }

  Future<void> _connectSignalR() async {
    try {
      final storageService = getIt<StorageService>();
      final token = await storageService.getAccessToken();
      
      if (token != null && token.isNotEmpty) {
        // For now, we'll just simulate SignalR connection
        // In real implementation, you would use actual SignalR package
        _setupNotificationCallbacks();
        print('✅ SignalR connection simulated');
      }
    } catch (e) {
      print('❌ SignalR connection failed: $e');
    }
  }

  Future<void> _disconnectSignalR() async {
    try {
      // Simulate disconnection
      print('✅ SignalR disconnected');
    } catch (e) {
      print('❌ SignalR disconnect error: $e');
    }
  }

  void _setupNotificationCallbacks() {
    // Simulate receiving notifications for testing
    // In real implementation, these would be called by SignalR
    
    // Example: Simulate receiving a new notification after 5 seconds
    if (kDebugMode) {
      Timer(const Duration(seconds: 5), () {
        _simulateNewNotification();
      });
    }
  }

  void _simulateNewNotification() {
    if (!_isInitialized) return;
    
    try {
      // Get a fresh instance of NotificationBloc
      if (!getIt.isRegistered<NotificationBloc>()) {
        print('⚠️ NotificationBloc is not registered');
        return;
      }
      
      final notificationBloc = getIt<NotificationBloc>();
      
      // Check if bloc is closed before adding events
      if (notificationBloc.isClosed) {
        print('⚠️ NotificationBloc is closed, skipping notification');
        return;
      }
      
      // Simulate a new notification JSON
      final simulatedNotificationJson = '''
      {
        "notificationId": "sim-${DateTime.now().millisecondsSinceEpoch}",
        "recipentUserId": null,
        "orderCode": null,
        "productId": null,
        "variantId": null,
        "livestreamId": null,
        "type": "FlashSale",
        "message": "🔥 Flash Sale mới đã bắt đầu! Giảm giá đến 50%",
        "linkUrl": null,
        "isRead": false,
        "created": "${DateTime.now().toIso8601String()}"
      }
      ''';
      
      notificationBloc.add(NewNotificationReceived(simulatedNotificationJson));
      print('📢 Simulated new notification sent to bloc');
    } catch (e) {
      print('❌ Error simulating notification: $e');
    }
  }

  void dispose() {
    _authStateSubscription?.cancel();
    _disconnectSignalR();
    _isInitialized = false;
  }
}
