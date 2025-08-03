import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/core/services/storage_service.dart';

// Bạn có thể define thêm model ChatMessage/ChatEvent tuỳ theo app

typedef SignalRStatusCallback = void Function(String status);
typedef OnReceiveMessage = void Function(Map<String, dynamic> message);

class SignalRService {
  late final HubConnection _connection;
  final String baseUrl;
  final StorageService storageService;
  final SignalRStatusCallback? onStatusChanged;
  final OnReceiveMessage? onReceiveMessage;

  bool _isConnected = false;

  SignalRService(
    this.baseUrl,
    this.storageService, {
    this.onStatusChanged,
    this.onReceiveMessage,
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

  /// Gửi message đến hub
  Future<void> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = "Text",
    String? attachmentUrl,
  }) async {
    if (!_isConnected) throw Exception("SignalR chưa kết nối!");
    try {
      final message = {
        "chatRoomId": chatRoomId,
        "content": content,
        "messageType": messageType,
        if (attachmentUrl != null) "attachmentUrl": attachmentUrl,
      };
      // Giả sử backend có method tên 'SendMessage' trên hub
      await _connection.invoke("SendMessage", args: [message]);
    } catch (e) {
      onStatusChanged?.call("❌ Gửi message thất bại: $e");
      rethrow;
    }
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
      if (arguments == null || arguments.isEmpty) return;
      // Dữ liệu truyền về thường là Map<String, dynamic>
      final data = arguments[0];
      if (data is Map<String, dynamic>) {
        onReceiveMessage?.call(data);
      } else if (data is String) {
        // Nếu backend trả về string json
        final map = jsonDecode(data);
        onReceiveMessage?.call(map);
      }
    });

    // Lắng nghe khi có user join/leave room hoặc các sự kiện khác
    _connection.on("UserJoined", (args) {
      onStatusChanged?.call("👤 User joined: ${args?[0]}");
    });

    _connection.on("UserLeft", (args) {
      onStatusChanged?.call("👤 User left: ${args?[0]}");
    });

    _connection.on("Typing", (args) {
      onStatusChanged?.call("✏️ Typing: $args");
    });

    // Lắng nghe trạng thái connection
    _connection.onclose((error) {
      _isConnected = false;
      onStatusChanged?.call("❌ SignalR bị ngắt kết nối: $error");
      // Ở đây có thể tự động reconnect hoặc thông báo lên UI
    });
    _connection.onreconnecting((error) {
      onStatusChanged?.call("🔄 SignalR đang reconnect...");
    });
    _connection.onreconnected((connectionId) {
      _isConnected = true;
      onStatusChanged?.call("✅ SignalR đã reconnect: $connectionId");
    });
  }
}
