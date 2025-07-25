import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../di/dependency_injection.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/notification/notification_event.dart';

class FirebaseNotificationService {
  static FirebaseNotificationService? _instance;
  static FirebaseNotificationService get instance {
    _instance ??= FirebaseNotificationService._();
    return _instance!;
  }

  FirebaseNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission for notifications
      await _requestPermission();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Setup Firebase Messaging
      await _setupFirebaseMessaging();
      
      _isInitialized = true;
      print('🔥 Firebase Notification Service initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Firebase Notification Service: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional permission');
    } else {
      print('❌ User declined or has not accepted permission');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'stream_cart_notifications',
      'Stream Cart Notifications',
      description: 'Notifications for Stream Cart app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Setup Firebase Messaging handlers
  Future<void> _setupFirebaseMessaging() async {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle messages when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
    // Get initial message if app was opened from a terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }

    // Get FCM token for this device
    final token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');
    
    // You can send this token to your server to target this device
    // TODO: Send token to your backend server
  }

  /// Handle notification when app is in foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📢 Foreground message received: ${message.notification?.title}');
    
    // Show local notification
    await _showLocalNotification(message);
    
    // Update notification bloc if needed
    _updateNotificationBloc(message);
  }

  /// Handle notification when app is opened from background
  void _handleBackgroundMessage(RemoteMessage message) {
    print('📱 Background message opened: ${message.notification?.title}');
    
    // Navigate to specific page based on notification data
    _handleNotificationNavigation(message);
    
    // Update notification bloc
    _updateNotificationBloc(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'stream_cart_notifications',
      'Stream Cart Notifications',
      channelDescription: 'Notifications for Stream Cart app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Stream Cart',
      message.notification?.body ?? 'Bạn có thông báo mới',
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _handleNotificationDataNavigation(data);
      } catch (e) {
        print('❌ Error parsing notification payload: $e');
      }
    }
  }

  /// Update notification bloc with new notification
  void _updateNotificationBloc(RemoteMessage message) {
    try {
      // Get fresh NotificationBloc instance
      if (!getIt.isRegistered<NotificationBloc>()) {
        print('⚠️ NotificationBloc is not registered');
        return;
      }

      final notificationBloc = getIt<NotificationBloc>();
      
      if (notificationBloc.isClosed) {
        print('⚠️ NotificationBloc is closed, skipping update');
        return;
      }

      // Convert Firebase message to your notification format
      final notificationJson = jsonEncode({
        'notificationId': message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'recipentUserId': message.data['recipentUserId'],
        'orderCode': message.data['orderCode'],
        'productId': message.data['productId'],
        'variantId': message.data['variantId'],
        'livestreamId': message.data['livestreamId'],
        'type': message.data['type'] ?? 'General',
        'message': message.notification?.body ?? message.data['message'] ?? '',
        'linkUrl': message.data['linkUrl'],
        'isRead': false,
        'created': DateTime.now().toIso8601String(),
      });

      notificationBloc.add(NewNotificationReceived(notificationJson));
      print('📢 Notification sent to bloc via FCM');
    } catch (e) {
      print('❌ Error updating notification bloc: $e');
    }
  }

  /// Handle notification navigation based on message data
  void _handleNotificationNavigation(RemoteMessage message) {
    _handleNotificationDataNavigation(message.data);
  }

  /// Handle navigation based on notification data
  void _handleNotificationDataNavigation(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    switch (type) {
      case 'FlashSale':
        // Navigate to flash sale page
        // TODO: Implement navigation
        break;
      case 'Order':
        final orderCode = data['orderCode'] as String?;
        if (orderCode != null) {
          // Navigate to order details
          // TODO: Implement navigation
        }
        break;
      case 'Product':
        final productId = data['productId'] as String?;
        if (productId != null) {
          // Navigate to product details
          // TODO: Implement navigation
        }
        break;
      case 'Livestream':
        final livestreamId = data['livestreamId'] as String?;
        if (livestreamId != null) {
          // Navigate to livestream
          // TODO: Implement navigation
        }
        break;
      default:
        // Navigate to notifications page
        // TODO: Implement navigation
        break;
    }
  }

  /// Handle background messages
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📱 Background message received: ${message.notification?.title}');
  
  // You can also update your local database here if needed
}
