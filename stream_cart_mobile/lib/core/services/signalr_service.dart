import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/core/services/storage_service.dart';

typedef SignalRStatusCallback = void Function(String status);
typedef OnReceiveChatMessage = void Function(Map<String, dynamic> message);
typedef OnReceiveLivestreamMessage = void Function(Map<String, dynamic> message);
typedef OnUserTyping = void Function(String userId, bool isTyping);
typedef OnUserJoinedRoom = void Function(String userId, String? userName);
typedef OnUserLeftRoom = void Function(String userId, String? userName);
typedef OnConnectionStateChanged = void Function(HubConnectionState state);
typedef OnError = void Function(String error);

class SignalRService {
  late HubConnection _connection;
  String baseUrl;
  StorageService storageService;
  SignalRStatusCallback? onStatusChanged;
  
  // ✅ Separate callbacks for chat and livestream
  OnReceiveChatMessage? onReceiveChatMessage;
  OnReceiveLivestreamMessage? onReceiveLivestreamMessage;
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
    this.onReceiveChatMessage,
    this.onReceiveLivestreamMessage,
    this.onUserTyping,
    this.onUserJoinedRoom,
    this.onUserLeftRoom,
    this.onConnectionStateChanged,
    this.onError,
  }) {
    _connection = HubConnectionBuilder()
        .withUrl(
          "$baseUrl/signalrchat", // ✅ Correct hub path
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            skipNegotiation: true, // ✅ Skip negotiation for WebSocket
            accessTokenFactory: () async {
              final token = await storageService.getAccessToken();
              return token ?? "";
            },
          ),
        )
        .withAutomaticReconnect([0, 2000, 10000, 30000]) // ✅ Better reconnect strategy
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
  // ignore: avoid_print
  print('[SignalR] Connected. id=${_connection.connectionId} url=${_connection.baseUrl}');
  onStatusChanged?.call("✅ Đã kết nối SignalR (id=${_connection.connectionId})");
    } catch (e) {
      _isConnected = false;
      onStatusChanged?.call("❌ Lỗi kết nối SignalR: $e");
      // ignore: avoid_print
      print('[SignalR] First connect attempt failed: $e');

      final err = e.toString().toLowerCase();
      final needFallback = err.contains('handshake') || err.contains('websocket') || err.contains('connection failed');
      if (needFallback) {
        // Fallback: rebuild connection WITH negotiation (allow server pick transport)
        try {
          onStatusChanged?.call('🔄 Thử kết nối lại với negotiation...');
          // Dispose old connection references
          try { await _connection.stop(); } catch (_) {}
          _connection = HubConnectionBuilder()
              .withUrl(
                "$baseUrl/signalrchat",
                HttpConnectionOptions(
                  // Cho phép negotiation chọn: WebSockets / SSE / LongPolling
                  accessTokenFactory: () async {
                    final token = await storageService.getAccessToken();
                    return token ?? "";
                  },
                  // Không set transport để signalr tự thương lượng
                ),
              )
              .withAutomaticReconnect([0, 2000, 10000, 30000])
              .build();
          _setupListeners();
          await _connection.start();
          _isConnected = true;
          // ignore: avoid_print
          print('[SignalR] Connected via fallback negotiation. id=${_connection.connectionId}');
          onStatusChanged?.call('✅ Kết nối thành công (fallback negotiation)');
          return; // success
        } catch (fallbackErr) {
          // ignore: avoid_print
          print('[SignalR] Fallback negotiation failed: $fallbackErr');
          // Second fallback: force longPolling
          try {
            onStatusChanged?.call('🔁 Thử lần cuối với longPolling...');
            try { await _connection.stop(); } catch (_) {}
            _connection = HubConnectionBuilder()
                .withUrl(
                  "$baseUrl/signalrchat",
                  HttpConnectionOptions(
                    transport: HttpTransportType.longPolling,
                    skipNegotiation: false,
                    accessTokenFactory: () async {
                      final token = await storageService.getAccessToken();
                      return token ?? "";
                    },
                  ),
                )
                .withAutomaticReconnect([0, 2000, 10000, 30000])
                .build();
            _setupListeners();
            await _connection.start();
            _isConnected = true;
            // ignore: avoid_print
            print('[SignalR] Connected via longPolling fallback. id=${_connection.connectionId}');
            onStatusChanged?.call('✅ Kết nối thành công (longPolling)');
            return;
          } catch (lpErr) {
            // ignore: avoid_print
            print('[SignalR] LongPolling fallback failed: $lpErr');
            onStatusChanged?.call('❌ Kết nối thất bại sau mọi fallback: $lpErr');
          }
        }
      }
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

  // ✅ CORRECT: Gửi tin nhắn chat room
  Future<void> sendChatMessage({
    required String chatRoomId,
    required String message,
  }) async {
    return _withRetry(() async {
  // ignore: avoid_print
  print('[SignalR] sendChatMessage chatRoomId=$chatRoomId message=$message');
      await _connection.invoke("SendMessageToChatRoom", args: [chatRoomId, message]);
      onStatusChanged?.call("✅ Đã gửi tin nhắn chat room");
    });
  }

  // ✅ CORRECT: Gửi tin nhắn livestream  
  Future<void> sendLivestreamMessage({
    required String livestreamId,
    required String message,
  }) async {
    return _withRetry(() async {
      await _connection.invoke("SendMessageToLivestream", args: [livestreamId, message]);
      onStatusChanged?.call("✅ Đã gửi tin nhắn livestream");
    });
  }

  // ✅ CORRECT: Join chat room
  Future<void> joinChatRoom(String chatRoomId) async {
    return _withRetry(() async {
      await ensureConnected();
      try {
        // ignore: avoid_print
        print('[SignalR] joinChatRoom invoke JoinDirectChatRoom($chatRoomId)');
        await _connection.invoke("JoinDirectChatRoom", args: [chatRoomId]);
        onStatusChanged?.call("✅ Đã join chat room $chatRoomId");
      } catch (e) {
        onStatusChanged?.call("❌ Join chat room thất bại: $e");
        rethrow;
      }
    });
  }

  // ✅ CORRECT: Leave chat room
  Future<void> leaveChatRoom(String chatRoomId) async {
    return _withRetry(() async {
      await ensureConnected();
      try {
        await _connection.invoke("LeaveDirectChatRoom", args: [chatRoomId]);
        onStatusChanged?.call("✅ Đã rời chat room $chatRoomId");
      } catch (e) {
        onStatusChanged?.call("❌ Leave chat room thất bại: $e");
        rethrow;
      }
    });
  }

  // ✅ CORRECT: Join livestream chat
  Future<void> joinLivestreamChat(String livestreamId) async {
    return _withRetry(() async {
      await ensureConnected();
      try {
        await _connection.invoke("JoinLivestreamChatRoom", args: [livestreamId]);
        onStatusChanged?.call("✅ Đã join livestream $livestreamId");
      } catch (e) {
        onStatusChanged?.call("❌ Join livestream thất bại: $e");
        rethrow;
      }
    });
  }

  // ✅ CORRECT: Leave livestream chat
  Future<void> leaveLivestreamChat(String livestreamId) async {
    return _withRetry(() async {
      await ensureConnected();
      try {
        await _connection.invoke("LeaveLivestreamChatRoom", args: [livestreamId]);
        onStatusChanged?.call("✅ Đã rời livestream $livestreamId");
      } catch (e) {
        onStatusChanged?.call("❌ Leave livestream thất bại: $e");
        rethrow;
      }
    });
  }

  // ✅ CORRECT: Gửi typing status
  Future<void> setTypingStatus(String chatRoomId, bool isTyping) async {
    if (!_isConnected) throw Exception("SignalR chưa kết nối!");
    try {
      await _connection.invoke("SetTypingStatus", args: [chatRoomId, isTyping]);
      onStatusChanged?.call("✅ Đã gửi typing status $isTyping");
    } catch (e) {
      onStatusChanged?.call("❌ Gửi typing thất bại: $e");
      rethrow;
    }
  }
/// ✅ CORRECT: Setup listeners theo tên events từ server
  void _setupListeners() {
    // ✅ Listen cho chat messages
    void handleIncoming(String eventName, List<Object?>? arguments) {
      try {
        // ignore: avoid_print
        print('[SignalR] Event $eventName raw args: $arguments');
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0];
          Map<String, dynamic> messageData;
          if (data is Map<String, dynamic>) {
            messageData = data.cast<String, dynamic>();
          } else if (data is String) {
            messageData = jsonDecode(data) as Map<String, dynamic>;
          } else {
            onError?.call("Chat message data không đúng format: ${data.runtimeType}");
            return;
          }
          // Unwrap nếu server bọc trong { message: {...} }
          if (messageData.containsKey('message') && messageData['message'] is Map) {
            // ignore: avoid_print
            print('[SignalR] Unwrapping nested message object');
            messageData = (messageData['message'] as Map).cast<String, dynamic>();
          }
          // Log các key để debug mapping
          // ignore: avoid_print
          print('[SignalR] Parsed message keys: ${messageData.keys.toList()}');
          onReceiveChatMessage?.call(messageData);
          onStatusChanged?.call("✅ Nhận chat message qua SignalR ($eventName)");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý chat message ($eventName): $e");
      }
    }

    _connection.on("ReceiveChatMessage", (arguments) {
      handleIncoming('ReceiveChatMessage', arguments);
    });

    // 👉 Backward compatibility: some hubs may emit 'ReceiveMessage'
    _connection.on("ReceiveMessage", (args) {
      handleIncoming('ReceiveMessage', args);
    });

    // 🔁 Thêm nhiều tên event có thể server dùng
    const possibleEvents = [
      'ReceiveDirectChatMessage',
      'ReceiveDirectMessage',
      'ReceiveMessageToChatRoom',
      'ReceiveMessageToDirectChatRoom',
      'ChatMessageReceived',
      'DirectChatMessageReceived'
    ];
    for (final eventName in possibleEvents) {
      _connection.on(eventName, (args) => handleIncoming(eventName, args));
    }

    // ✅ Listen cho livestream messages
    _connection.on("ReceiveLivestreamMessage", (arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0];
          Map<String, dynamic> messageData;
          
          if (data is Map<String, dynamic>) {
            messageData = data;
          } else if (data is String) {
            messageData = jsonDecode(data);
          } else {
            onError?.call("Livestream message data không đúng format: ${data.runtimeType}");
            return;
          }
          
          onReceiveLivestreamMessage?.call(messageData);
          onStatusChanged?.call("✅ Nhận livestream message qua SignalR");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý livestream message: $e");
      }
    });

    // ✅ Listen cho typing indicator
    _connection.on("UserTyping", (args) {
      try {
        if (args != null && args.isNotEmpty) {
          final data = args[0];
          if (data is Map<String, dynamic>) {
            final userId = data['UserId'] as String?;
            final isTyping = data['IsTyping'] as bool?;
            
            if (userId != null && isTyping != null) {
              onUserTyping?.call(userId, isTyping);
              onStatusChanged?.call("👤 User $userId ${isTyping ? 'đang gõ' : 'dừng gõ'}");
            }
          }
        }
      } catch (e) {
        onError?.call("Lỗi xử lý typing indicator: $e");
      }
    });

    // ✅ Listen cho user joined
    _connection.on("UserJoined", (args) {
      try {
        if (args != null && args.isNotEmpty) {
          final data = args[0];
          if (data is Map<String, dynamic>) {
            final userId = data['UserId'] as String?;
            final userName = data['UserName'] as String?;
            
            if (userId != null) {
              onUserJoinedRoom?.call(userId, userName);
              onStatusChanged?.call("👤 User $userId joined room");
            }
          }
        }
      } catch (e) {
onError?.call("Lỗi xử lý user joined: $e");
      }
    });

    // ✅ Listen cho user left
    _connection.on("UserLeft", (args) {
      try {
        if (args != null && args.isNotEmpty) {
          final data = args[0];
          if (data is Map<String, dynamic>) {
            final userId = data['UserId'] as String?;
            final userName = data['UserName'] as String?;
            
            if (userId != null) {
              onUserLeftRoom?.call(userId, userName);
              onStatusChanged?.call("👤 User $userId left room");
            }
          }
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
    onReceiveChatMessage = null;
    onReceiveLivestreamMessage = null;
    onUserTyping = null;
    onUserJoinedRoom = null;
    onUserLeftRoom = null;
    onConnectionStateChanged = null;
    onError = null;
    onStatusChanged = null;
  }

  /// Cleanup toàn bộ service
  Future<void> dispose() async {
    removeListeners();
    if (_isConnected) {
      await disconnect();
    }
    onStatusChanged?.call("🧹 SignalR service đã được dispose");
  }
}