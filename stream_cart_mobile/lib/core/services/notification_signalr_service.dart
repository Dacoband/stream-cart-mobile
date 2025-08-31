import 'package:signalr_core/signalr_core.dart';
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
      final serverUrl = '${Env.baseUrl}/hubs/notification';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            serverUrl,
            HttpConnectionOptions(
              accessTokenFactory: () async => token,
              transport: HttpTransportType.webSockets,
            ),
          )
          .withAutomaticReconnect()
          .build();

      // Handle connection state changes
      _hubConnection?.onclose((error) async {
        _isConnected = false;
      });

      _hubConnection?.onreconnecting((error) async {
      });

      _hubConnection?.onreconnected((connectionId) async {
        _isConnected = true;
      });

      // Register notification handlers
      _hubConnection?.on('ReceiveNotification', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final notificationJson = arguments[0] as String;
          onNotificationReceived?.call(notificationJson);
        }
      });

      _hubConnection?.on('NotificationUpdated', (arguments) {
        if (arguments != null && arguments.length >= 2) {
          final notificationId = arguments[0] as String;
          final isRead = arguments[1] as bool;
          onNotificationUpdated?.call(notificationId, isRead);
        }
      });

      _hubConnection?.on('UnreadCountChanged', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final count = arguments[0] as int;
          onUnreadCountChanged?.call(count);
        }
      });
      await _hubConnection?.start();
      _isConnected = true;
      await joinNotificationGroup();

    } catch (e) {
      _isConnected = false;
    }
  }

  Future<void> joinNotificationGroup() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await _hubConnection!.invoke('JoinNotificationGroup');
      } catch (e) {
        return Future.error('Failed to join notification group: $e');
      }
    }
  }

  Future<void> leaveNotificationGroup() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await _hubConnection!.invoke('LeaveNotificationGroup');
      } catch (e) {
        return Future.error('Failed to leave notification group: $e');
      }
    }
  }

  Future<void> disconnect() async {
    if (_isConnected && _hubConnection != null) {
      try {
        await leaveNotificationGroup();
        await _hubConnection!.stop();
        _isConnected = false;
      } catch (e) {
        return Future.error('Failed to disconnect: $e');
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
