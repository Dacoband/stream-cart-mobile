import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/core/services/storage_service.dart';


typedef SignalRStatusCallback = void Function(String status);
typedef OnReceiveMessage = void Function(Map<String, dynamic> message);
typedef OnUserTyping = void Function(String userId, String chatRoomId, bool isTyping, String? userName);
typedef OnUserJoinedRoom = void Function(String userId, String chatRoomId, String? userName);
typedef OnUserLeftRoom = void Function(String userId, String chatRoomId, String? userName);
typedef OnConnectionStateChanged = void Function(HubConnectionState state);
typedef OnError = void Function(String error);

class SignalRService {
  late HubConnection _connection;
  String baseUrl;
  StorageService storageService;
  SignalRStatusCallback? onStatusChanged;
  OnReceiveMessage? onReceiveMessage;

  OnUserTyping? onUserTyping;
  OnUserJoinedRoom? onUserJoinedRoom;
  OnUserLeftRoom? onUserLeftRoom;
  OnConnectionStateChanged? onConnectionStateChanged;
  OnError? onError;

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
          baseUrl,
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            accessTokenFactory: () async {
              final token = await storageService.getAccessToken();
              return token ?? "";
            },
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
        if (arguments == null || arguments.isEmpty) {
          return;
        }
        
        final data = arguments[0];
        
        if (data is Map<String, dynamic>) {
          onReceiveMessage?.call(data);
          onStatusChanged?.call("✅ Đã nhận tin nhắn qua SignalR");
        } else if (data is String) {
          final map = jsonDecode(data);
          onReceiveMessage?.call(map);
          onStatusChanged?.call("✅ Đã nhận tin nhắn qua SignalR (JSON)");
        } else {
          onError?.call("Dữ liệu tin nhắn không đúng định dạng: ${data.runtimeType}");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý tin nhắn: $e");
      }
    });

    // Lắng nghe typing với thông tin chi tiết hơn
    _connection.on("Typing", (args) {
      try {
        if (args != null && args.length >= 4) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          final isTyping = args[2] as bool;
          final userName = args[3] as String?; // Thêm tham số userName
          onUserTyping?.call(userId, chatRoomId, isTyping, userName);
        }
      } catch (e) {
        onError?.call("Lỗi xử lý typing indicator: $e");
      }
    });

    // User joined với thông tin chi tiết
    _connection.on("UserJoined", (args) {
      try {
        if (args != null && args.length >= 3) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          final userName = args[2] as String?; // Thêm tham số userName
          onUserJoinedRoom?.call(userId, chatRoomId, userName);
          onStatusChanged?.call("👤 User $userId joined room $chatRoomId");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý user joined: $e");
      }
    });

    // User left với thông tin chi tiết
    _connection.on("UserLeft", (args) {
      try {
        if (args != null && args.length >= 3) {
          final userId = args[0] as String;
          final chatRoomId = args[1] as String;
          final userName = args[2] as String?;
          onUserLeftRoom?.call(userId, chatRoomId, userName);
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

  /// Remove all listeners để tránh memory leaks
  void removeListeners() {
    onReceiveMessage = null;
    onUserTyping = null;
    onUserJoinedRoom = null;
    onUserLeftRoom = null;
    onConnectionStateChanged = null;
    onError = null;
    onStatusChanged = null;
  }

  /// Cleanup toàn bộ service
  Future<void> dispose() async {
    // Remove listeners trước
    removeListeners();
    
    // Disconnect nếu đang connected
    if (_isConnected) {
      await disconnect();
    }
    
    // Có thể thêm cleanup khác nếu cần
    onStatusChanged?.call("🧹 SignalR service đã được dispose");
  }

  // Thêm method để reset và setup lại listeners
  void resetListeners({
    SignalRStatusCallback? onStatusChanged,
    OnReceiveMessage? onReceiveMessage,
    OnUserTyping? onUserTyping,
    OnUserJoinedRoom? onUserJoinedRoom,
    OnUserLeftRoom? onUserLeftRoom,
    OnConnectionStateChanged? onConnectionStateChanged,
    OnError? onError,
  }) {
    // Remove old listeners
    removeListeners();
    
    // Set new listeners
    this.onStatusChanged = onStatusChanged;
    this.onReceiveMessage = onReceiveMessage;
    this.onUserTyping = onUserTyping;
    this.onUserJoinedRoom = onUserJoinedRoom;
    this.onUserLeftRoom = onUserLeftRoom;
    this.onConnectionStateChanged = onConnectionStateChanged;
    this.onError = onError;
  }
}
