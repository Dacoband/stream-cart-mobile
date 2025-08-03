import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/core/services/storage_service.dart';

// Bạn có thể define thêm model ChatMessage/ChatEvent tuỳ theo app

typedef SignalRStatusCallback = void Function(String status);
typedef OnReceiveMessage = void Function(Map<String, dynamic> message);
// Thêm typedef cho các callbacks khác
typedef OnUserTyping = void Function(String userId, String chatRoomId, bool isTyping);
typedef OnUserJoinedRoom = void Function(String userId, String chatRoomId);
typedef OnUserLeftRoom = void Function(String userId, String chatRoomId);
typedef OnConnectionStateChanged = void Function(HubConnectionState state);
typedef OnError = void Function(String error);

class SignalRService {
  late final HubConnection _connection;
  final String baseUrl;
  final StorageService storageService;
  final SignalRStatusCallback? onStatusChanged;
  final OnReceiveMessage? onReceiveMessage;

  final OnUserTyping? onUserTyping;
  final OnUserJoinedRoom? onUserJoinedRoom;
  final OnUserLeftRoom? onUserLeftRoom;
  final OnConnectionStateChanged? onConnectionStateChanged;
  final OnError? onError;

  bool _isConnected = false;

  SignalRService(
    this.baseUrl,
    this.storageService, {
    this.onStatusChanged,
    this.onReceiveMessage,
    this.onUserTyping,
    this.onUserJoinedRoom,
    this.onUserLeftRoom,
    this.onConnectionStateChanged,
    this.onError,
  }) {
    _connection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/chatHub',
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            accessTokenFactory: () async => await storageService.getAccessToken() ?? "",
          ),
        )
        .withAutomaticReconnect()
        .build();

    _setupListeners();
  }

  /// Kết nối đến SignalR hub
  Future<void> connect() async {
    if (_connection.state == HubConnectionState.connected) {
      onStatusChanged?.call("Đã kết nối SignalR");
      _isConnected = true;
      return;
    }
    onStatusChanged?.call("Đang kết nối SignalR...");
    try {
      await _connection.start();
      _isConnected = true;
      onStatusChanged?.call("✅ Đã kết nối SignalR");
    } catch (e) {
      _isConnected = false;
      onStatusChanged?.call("❌ Lỗi kết nối SignalR: $e");
      rethrow;
    }
  }

  /// Ngắt kết nối hub
  Future<void> disconnect() async {
    try {
      await _connection.stop();
      _isConnected = false;
      onStatusChanged?.call("🔌 Đã ngắt kết nối SignalR");
    } catch (e) {
      onStatusChanged?.call("❌ Lỗi ngắt kết nối SignalR: $e");
    }
  }

  bool get isConnected => _isConnected;

  // Cải tiến sendMessage với retry
  Future<void> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = "Text",
    String? attachmentUrl,
  }) async {
    return _withRetry(() async {
      final message = {
        "chatRoomId": chatRoomId,
        "content": content,
        "messageType": messageType,
        if (attachmentUrl != null) "attachmentUrl": attachmentUrl,
      };
      await _connection.invoke("SendMessage", args: [message]);
      onStatusChanged?.call("✅ Đã gửi tin nhắn");
    });
  }

  /// Join một chat room
  Future<void> joinRoom(String chatRoomId) async {
    if (!_isConnected) throw Exception("SignalR chưa kết nối!");
    try {
      await _connection.invoke("JoinRoom", args: [chatRoomId]);
      onStatusChanged?.call("Đã join phòng $chatRoomId");
    } catch (e) {
      onStatusChanged?.call("❌ Join room thất bại: $e");
      rethrow;
    }
  }

  /// Leave chat room
  Future<void> leaveRoom(String chatRoomId) async {
    if (!_isConnected) throw Exception("SignalR chưa kết nối!");
    try {
      await _connection.invoke("LeaveRoom", args: [chatRoomId]);
      onStatusChanged?.call("Đã rời phòng $chatRoomId");
    } catch (e) {
      onStatusChanged?.call("❌ Leave room thất bại: $e");
      rethrow;
    }
  }

  /// Gửi typing indicator
  Future<void> sendTyping(String chatRoomId, bool isTyping) async {
    if (!_isConnected) throw Exception("SignalR chưa kết nối!");
    try {
      await _connection.invoke("Typing", args: [chatRoomId, isTyping]);
      onStatusChanged?.call("Đã gửi trạng thái typing $isTyping phòng $chatRoomId");
    } catch (e) {
      onStatusChanged?.call("❌ Gửi typing thất bại: $e");
      rethrow;
    }
  }

  /// Lắng nghe các signal từ backend
  void _setupListeners() {
    // Lắng nghe tin nhắn mới
    _connection.on("ReceiveMessage", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;
        final data = arguments[0];
        if (data is Map<String, dynamic>) {
          onReceiveMessage?.call(data);
        } else if (data is String) {
          final map = jsonDecode(data);
          onReceiveMessage?.call(map);
        }
      } catch (e) {
        onError?.call("Lỗi xử lý tin nhắn: $e");
      }
    });

    // Lắng nghe typing với thông tin chi tiết hơn
    _connection.on("Typing", (args) {
      try {
        if (args != null && args.length >= 3) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          final isTyping = args[2] as bool;
          onUserTyping?.call(userId, chatRoomId, isTyping);
        }
      } catch (e) {
        onError?.call("Lỗi xử lý typing indicator: $e");
      }
    });

    // User joined với thông tin chi tiết
    _connection.on("UserJoined", (args) {
      try {
        if (args != null && args.length >= 2) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          onUserJoinedRoom?.call(userId, chatRoomId);
          onStatusChanged?.call("👤 User $userId joined room $chatRoomId");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý user joined: $e");
      }
    });

    // User left với thông tin chi tiết
    _connection.on("UserLeft", (args) {
      try {
        if (args != null && args.length >= 2) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          onUserLeftRoom?.call(userId, chatRoomId);
          onStatusChanged?.call("👤 User $userId left room $chatRoomId");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý user left: $e");
      }
    });

    // Connection state changes
    _connection.onclose((error) {
      _isConnected = false;
      onConnectionStateChanged?.call(HubConnectionState.disconnected);
      onStatusChanged?.call("❌ SignalR bị ngắt kết nối: $error");
    });

    _connection.onreconnecting((error) {
      onConnectionStateChanged?.call(HubConnectionState.reconnecting);
      onStatusChanged?.call("🔄 SignalR đang reconnect...");
    });

    _connection.onreconnected((connectionId) {
      _isConnected = true;
      onConnectionStateChanged?.call(HubConnectionState.connected);
      onStatusChanged?.call("✅ SignalR đã reconnect: $connectionId");
    });
  }

  // Thêm method để check và auto-reconnect
  Future<void> ensureConnected() async {
    if (!_isConnected || _connection.state != HubConnectionState.connected) {
      await connect();
    }
  }

  // Thêm method để handle retry logic
  Future<T> _withRetry<T>(Future<T> Function() operation, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        await ensureConnected();
        return await operation();
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: i + 1));
      }
    }
    throw Exception("Operation failed after $maxRetries retries");
  }

  // Dispose method để cleanup
  void dispose() {
    disconnect();
  }
}
