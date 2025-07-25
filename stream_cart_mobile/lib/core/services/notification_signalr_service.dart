import 'package:signalr_netcore/signalr_client.dart';
import '../config/env.dart';

class NotificationSignalRService {
  static NotificationSignalRService? _instance;
  HubConnection? _hubConnection;
  bool _isConnected = false;

  // Singleton pattern
  static NotificationSignalRService get instance {
    _instance ??= NotificationSignalRService._();
    return _instance!;
  }

  NotificationSignalRService._();

  // Callback functions
  Function(String)? onNotificationReceived;
  Function(String, bool)? onNotificationUpdated;
  Function(int)? onUnreadCountChanged;

  Future<void> connect(String token) async {
    if (_isConnected) return;

    try {
      final serverUrl = '${Env.baseUrl}/notificationHub';
      
      _hubConnection = HubConnectionBuilder()
          .withUrl(serverUrl, options: HttpConnectionOptions(
            accessTokenFactory: () => Future.value(token),
          ))
          .build();

      // Handle connection state changes
      _hubConnection?.onclose(({error}) {
        print('SignalR connection closed: $error');
        _isConnected = false;
      });

      _hubConnection?.onreconnecting(({error}) {
        print('SignalR reconnecting: $error');
      });

      _hubConnection?.onreconnected(({connectionId}) {
        print('SignalR reconnected: $connectionId');
        _isConnected = true;
      });

      // Register notification handlers
      _hubConnection?.on('ReceiveNotification', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final notificationJson = arguments[0] as String;
          print('📢 New notification received: $notificationJson');
          onNotificationReceived?.call(notificationJson);
        }
      });

      _hubConnection?.on('NotificationUpdated', (arguments) {
        if (arguments != null && arguments.length >= 2) {
          final notificationId = arguments[0] as String;
          final isRead = arguments[1] as bool;
          print('📝 Notification updated: $notificationId, isRead: $isRead');
          onNotificationUpdated?.call(notificationId, isRead);
        }
      });

      _hubConnection?.on('UnreadCountChanged', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final count = arguments[0] as int;
          print('🔢 Unread count changed: $count');
          onUnreadCountChanged?.call(count);
        }
      });

      // Start connection
      await _hubConnection?.start();
      _isConnected = true;
      print('✅ SignalR connected successfully');

      // Join notification group for current user
      await joinNotificationGroup();

    } catch (e) {
      print('❌ SignalR connection failed: $e');
      _isConnected = false;
    }
  }

  Future<void> joinNotificationGroup() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await _hubConnection!.invoke('JoinNotificationGroup');
        print('✅ Joined notification group');
      } catch (e) {
        print('❌ Failed to join notification group: $e');
      }
    }
  }

  Future<void> leaveNotificationGroup() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await _hubConnection!.invoke('LeaveNotificationGroup');
        print('✅ Left notification group');
      } catch (e) {
        print('❌ Failed to leave notification group: $e');
      }
    }
  }

  Future<void> disconnect() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await leaveNotificationGroup();
        await _hubConnection!.stop();
        _isConnected = false;
        print('✅ SignalR disconnected');
      } catch (e) {
        print('❌ SignalR disconnect error: $e');
      }
    }
  }

  bool get isConnected => _isConnected;

  void dispose() {
    onNotificationReceived = null;
    onNotificationUpdated = null;
    onUnreadCountChanged = null;
  }
}
