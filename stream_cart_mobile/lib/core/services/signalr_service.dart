import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'package:stream_cart_mobile/core/services/storage_service.dart';

typedef SignalRStatusCallback = void Function(String status);
typedef OnReceiveChatMessage = void Function(Map<String, dynamic> message);
typedef OnReceiveLivestreamMessage = void Function(Map<String, dynamic> message);
typedef OnReceiveViewerStats = void Function(Map<String, dynamic> stats);
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
  OnReceiveChatMessage? onReceiveChatMessage;
  OnReceiveLivestreamMessage? onReceiveLivestreamMessage;
  OnReceiveViewerStats? onReceiveViewerStats;
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
          "$baseUrl/signalrchat", 
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            skipNegotiation: true,
            accessTokenFactory: () async {
              final token = await storageService.getAccessToken();
              return token ?? "";
            },
          ),
        )
        .withAutomaticReconnect([0, 2000, 10000, 30000]) 
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
      onStatusChanged?.call("✅ Đã kết nối SignalR (id=${_connection.connectionId})");
    } catch (e) {
      _isConnected = false;
      onStatusChanged?.call("❌ Lỗi kết nối SignalR: $e");
      final err = e.toString().toLowerCase();
      final needFallback = err.contains('handshake') || err.contains('websocket') || err.contains('connection failed');
      if (needFallback) {
        try {
          onStatusChanged?.call('🔄 Thử kết nối lại với negotiation...');
          try { await _connection.stop(); } catch (_) {}
          _connection = HubConnectionBuilder()
              .withUrl(
                "$baseUrl/signalrchat",
                HttpConnectionOptions(
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
          onStatusChanged?.call('✅ Kết nối thành công (fallback negotiation)');
          return; 
        } catch (fallbackErr) {
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
            onStatusChanged?.call('✅ Kết nối thành công (longPolling)');
            return;
          } catch (lpErr) {
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

  // Gửi tin nhắn chat room
  Future<void> sendChatMessage({
    required String chatRoomId,
    required String message,
  }) async {
    return _withRetry(() async {
      await _connection.invoke("SendMessageToChatRoom", args: [chatRoomId, message]);
      onStatusChanged?.call("✅ Đã gửi tin nhắn chat room");
    });
  }

  // Gửi tin nhắn livestream  
  Future<void> sendLivestreamMessage({
    required String livestreamId,
    required String message,
  }) async {
    return _withRetry(() async {
      await ensureConnected();
      final methods = <String>[
        'SendMessageToLivestream',
        'SendMessageToLiveStream',
        'SendMessageToLivestreamRoom',
        'SendMessageToLiveStreamRoom',
      ];
      dynamic lastErr;
      for (final m in methods) {
        try {
          await _connection.invoke(m, args: [livestreamId, message]);
          onStatusChanged?.call("✅ Đã gửi tin nhắn livestream qua $m");
          return;
        } catch (e) {
          lastErr = e;
        }
      }
      onStatusChanged?.call('❌ Gửi tin nhắn livestream thất bại: $lastErr');
      throw lastErr ?? Exception('Unknown SignalR error');
    });
  }

  Future<void> joinChatRoom(String chatRoomId) async {
    return _withRetry(() async {
      await ensureConnected();
      try {
        await _connection.invoke("JoinDirectChatRoom", args: [chatRoomId]);
        onStatusChanged?.call("✅ Đã join chat room $chatRoomId");
      } catch (e) {
        onStatusChanged?.call("❌ Join chat room thất bại: $e");
        rethrow;
      }
    });
  }

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

  void _setupListeners() {
    bool _hasLivestreamId(Map<String, dynamic> m) {
      return m.containsKey('livestreamId') || m.containsKey('liveStreamId') ||
            m.containsKey('LivestreamId') || m.containsKey('LiveStreamId');
    }

    void handleIncoming(String eventName, List<Object?>? arguments) {
      try {
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
          if (messageData.containsKey('data') && messageData['data'] is Map &&
              (messageData['data'] as Map).containsKey('message') && (messageData['data']['message'] is Map)) {
            messageData = (messageData['data']['message'] as Map).cast<String, dynamic>();
          } else if (messageData.containsKey('message') && messageData['message'] is Map) {
            messageData = (messageData['message'] as Map).cast<String, dynamic>();
          } else if (messageData.containsKey('data') && messageData['data'] is Map) {
            final d = (messageData['data'] as Map).cast<String, dynamic>();
            if (_hasLivestreamId(d) || d.containsKey('message')) {
              messageData = d;
            }
          }
          onReceiveChatMessage?.call(messageData);
          if (_hasLivestreamId(messageData)) {
            onReceiveLivestreamMessage?.call(messageData);
          }
          onStatusChanged?.call("✅ Nhận chat message qua SignalR ($eventName)");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý chat message ($eventName): $e");
      }
    }

    _connection.on("ReceiveChatMessage", (arguments) {
      handleIncoming('ReceiveChatMessage', arguments);
    });
    _connection.on("ReceiveMessage", (args) {
      handleIncoming('ReceiveMessage', args);
    });

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

    // Listen cho livestream messages (support multiple possible event names)
    void handleLivestreamIncoming(String eventName, List<Object?>? arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0];
          Map<String, dynamic> messageData;
          if (data is Map<String, dynamic>) {
            messageData = data.cast<String, dynamic>();
          } else if (data is String) {
            messageData = jsonDecode(data) as Map<String, dynamic>;
          } else {
            onError?.call("Livestream message data không đúng format: ${data.runtimeType}");
            return;
          }
          if (messageData.containsKey('data') && messageData['data'] is Map &&
              (messageData['data'] as Map).containsKey('message') && (messageData['data']['message'] is Map)) {
            messageData = (messageData['data']['message'] as Map).cast<String, dynamic>();
          } else if (messageData.containsKey('message') && messageData['message'] is Map) {
            messageData = (messageData['message'] as Map).cast<String, dynamic>();
          }
          onReceiveLivestreamMessage?.call(messageData);
          onStatusChanged?.call("Nhận livestream message qua SignalR ($eventName)");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý livestream message: $e");
      }
    }

    const possibleLivestreamEvents = [
      'ReceiveLivestreamMessage',
      'ReceiveMessageToLivestream',
      'ReceiveLivestreamChatMessage',
      'LivestreamMessageReceived',
      'ReceiveMessageToLivestreamRoom',
      'MessageToLivestream',
      'ReceiveMessageToLiveStream',
      'ReceiveLiveStreamMessage',
      'LiveStreamMessageReceived',
      'ReceiveMessageToLiveStreamRoom',
    ];
    for (final eventName in possibleLivestreamEvents) {
      _connection.on(eventName, (args) => handleLivestreamIncoming(eventName, args));
    }

    // Listen cho viewer stats (thống kê người xem)
    _connection.on("ReceiveViewerStats", (arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0];
          Map<String, dynamic> stats;
          if (data is Map<String, dynamic>) {
            stats = data;
          } else if (data is String) {
            stats = jsonDecode(data) as Map<String, dynamic>;
          } else {
            onError?.call("Viewer stats payload không đúng format: ${data.runtimeType}");
            return;
          }
          onReceiveViewerStats?.call(stats);
          onStatusChanged?.call("📊 Nhận viewer stats qua SignalR");
        }
      } catch (e) {
        onError?.call("Lỗi xử lý viewer stats: $e");
      }
    });

    // Listen cho typing indicator
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

    // Listen cho user joined
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

    // Listen cho user left
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

  Future<void> ensureConnected() async {
    if (!_isConnected || _connection.state != HubConnectionState.connected) {
      await connect();
    }
  }

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

  void removeListeners() {
    onReceiveChatMessage = null;
    onReceiveLivestreamMessage = null;
    onReceiveViewerStats = null;
    onUserTyping = null;
    onUserJoinedRoom = null;
    onUserLeftRoom = null;
    onConnectionStateChanged = null;
    onError = null;
    onStatusChanged = null;
  }

  Future<void> dispose() async {
    removeListeners();
    if (_isConnected) {
      await disconnect();
    }
    onStatusChanged?.call("SignalR service đã được dispose");
  }
}