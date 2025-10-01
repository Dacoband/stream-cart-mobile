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

// Product-related callbacks (payloads are normalized Map<String, dynamic>)
typedef OnPinnedProductsUpdated = void Function(Map<String, dynamic> payload);
typedef OnProductAdded = void Function(Map<String, dynamic> payload);
typedef OnProductRemoved = void Function(Map<String, dynamic> payload);
typedef OnProductUpdated = void Function(Map<String, dynamic> payload);
typedef OnProductPinStatusChanged = void Function(Map<String, dynamic> payload);
typedef OnProductStockUpdated = void Function(Map<String, dynamic> payload);

class SignalRService {
  late HubConnection _connection;
  HubConnection get connection => _connection;
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

  // Product-related listeners
  OnPinnedProductsUpdated? onPinnedProductsUpdated;
  OnProductAdded? onProductAdded;
  OnProductRemoved? onProductRemoved;
  OnProductUpdated? onLivestreamProductUpdated;
  OnProductPinStatusChanged? onProductPinStatusChanged;
  OnProductPinStatusChanged? onLivestreamProductPinStatusChanged;
  OnProductStockUpdated? onProductStockUpdated;
  OnProductStockUpdated? onLivestreamProductStockUpdated;

  bool _isConnected = false;
  /// Khi true, không forward các sự kiện hiện diện (UserJoined/UserLeft)
  /// và lọc bỏ các chat message kiểu "đã tham gia livestream" khỏi UI.
  bool suppressPresenceDisplay = false;
  /// When true, presence-related hub invokes (join/leave/viewing) will be suppressed.
  /// Use this to avoid notifying others when entering a livestream.
  bool suppressPresenceEvents = false;

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
  onConnectionStateChanged?.call(HubConnectionState.connected);
      return;
    }
    
    onStatusChanged?.call("Đang kết nối SignalR...");
    try {
      await _connection.start();
      _isConnected = true;
      onStatusChanged?.call("✅ Đã kết nối SignalR (id=${_connection.connectionId})");
  onConnectionStateChanged?.call(HubConnectionState.connected);
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
          onConnectionStateChanged?.call(HubConnectionState.connected);
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
            onConnectionStateChanged?.call(HubConnectionState.connected);
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

  // ---------- Product actions ----------
  Future<void> updateProductStock(String livestreamId, String productId, String? variantId, int newStock) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('UpdateProductStock', args: [livestreamId, productId, variantId, newStock]);
      onStatusChanged?.call('✅ Đã cập nhật stock sản phẩm');
    });
  }

  Future<void> pinProduct(String livestreamId, String productId, String? variantId, bool isPin) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('PinProduct', args: [livestreamId, productId, variantId, isPin]);
      onStatusChanged?.call('✅ Đã cập nhật trạng thái pin sản phẩm');
    });
  }

  Future<void> addProductToLivestream(
    String livestreamId,
    String productId,
    String? variantId,
    num price,
    int stock,
    {bool isPin = false}
  ) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('AddProductToLivestream', args: [livestreamId, productId, variantId, price, stock, isPin]);
      onStatusChanged?.call('✅ Đã thêm sản phẩm vào livestream');
    });
  }

  Future<void> removeProductFromLivestream(String livestreamId, String productId, String? variantId) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('RemoveProductFromLivestream', args: [livestreamId, productId, variantId]);
      onStatusChanged?.call('✅ Đã xoá sản phẩm khỏi livestream');
    });
  }

  Future<dynamic> getLivestreamProducts(String livestreamId) async {
    return _withRetry(() async {
      await ensureConnected();
      return _connection.invoke('GetLivestreamProducts', args: [livestreamId]);
    });
  }

  Future<dynamic> getPinnedProducts(String livestreamId) async {
    return _withRetry(() async {
      await ensureConnected();
      return _connection.invoke('GetPinnedProducts', args: [livestreamId]);
    });
  }

  // ---------- Viewing helpers (some servers require this to receive room events) ----------
  Future<void> startViewingLivestream(String livestreamId) async {
    if (suppressPresenceEvents) {
      onStatusChanged?.call('🔇 Bỏ qua StartViewingLivestream (suppressPresenceEvents=true)');
      return;
    }
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('StartViewingLivestream', args: [livestreamId]);
      onStatusChanged?.call('👀 Bắt đầu xem livestream $livestreamId');
    });
  }

  Future<void> stopViewingLivestream(String livestreamId) async {
    if (suppressPresenceEvents) {
      onStatusChanged?.call('🔇 Bỏ qua StopViewingLivestream (suppressPresenceEvents=true)');
      return;
    }
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('StopViewingLivestream', args: [livestreamId]);
      onStatusChanged?.call('👋 Dừng xem livestream $livestreamId');
    });
  }

  Future<void> updateLivestreamProductById(String id, num price, int stock, bool isPin) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('UpdateLivestreamProductById', args: [id, price, stock, isPin]);
      onStatusChanged?.call('✅ Đã cập nhật sản phẩm theo id');
    });
  }

  Future<void> pinLivestreamProductById(String id, bool isPin) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('PinLivestreamProductById', args: [id, isPin]);
    });
  }

  Future<void> updateLivestreamProductStockById(String id, int newStock) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('UpdateLivestreamProductStockById', args: [id, newStock]);
    });
  }

  Future<void> deleteLivestreamProductById(String id) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('DeleteLivestreamProductById', args: [id]);
    });
  }

  Future<void> softDeleteLivestreamProductById(String id, {String reason = 'Removed by seller'}) async {
    return _withRetry(() async {
      await ensureConnected();
      await _connection.invoke('SoftDeleteLivestreamProductById', args: [id, reason]);
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
    if (suppressPresenceEvents) {
      onStatusChanged?.call('🔇 Bỏ qua JoinLivestreamChat (suppressPresenceEvents=true)');
      return;
    }
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
    if (suppressPresenceEvents) {
      onStatusChanged?.call('🔇 Bỏ qua LeaveLivestreamChat (suppressPresenceEvents=true)');
      return;
    }
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
    Map<String, dynamic> _decodeFirstArg(List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0];
        if (data is Map<String, dynamic>) return data;
        if (data is Map) return Map<String, dynamic>.from(data);
        if (data is String) {
          try {
            final decoded = jsonDecode(data);
            if (decoded is Map) return Map<String, dynamic>.from(decoded);
          } catch (_) {}
        }
      }
      return <String, dynamic>{};
    }

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
          // // Lọc bỏ thông điệp hệ thống "đã tham gia livestream" nếu cần ẩn
          // if (suppressPresenceDisplay && _looksLikeJoinPresenceMessage(messageData)) {
          //   return;
          // }
     

          onReceiveChatMessage?.call(messageData);
          if (_hasLivestreamId(messageData)) {
            onReceiveLivestreamMessage?.call(messageData);
          }
          // onStatusChanged?.call("✅ Nhận chat message qua SignalR ($eventName)"); // Tắt log để tránh spam
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
      'DirectChatMessageReceived',
      'DirectChatMessageReceived',
      'MessageReceived',
      'NewMessage',
      'NewChatMessage',
      'ReceiveRoomMessage',
      'RoomMessageReceived',
      'ReceiveDirectRoomMessage',
      'ReceiveMessageFromChatRoom',
      'ReceiveChatMessage',
    ];
    for (final eventName in possibleEvents) {
      _connection.on(eventName, (args) => handleIncoming(eventName, args));
    }
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
          // onStatusChanged?.call("Nhận livestream message qua SignalR ($eventName)"); // Tắt log để tránh spam
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

    // ---------- Product & Pinned events ----------
    void _emitPinnedProductsUpdated(List<Object?>? args, String evt) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      onPinnedProductsUpdated?.call(payload);
      // onStatusChanged?.call('📌 Nhận pinned products ($evt)'); // Tắt log để tránh spam
    }

  _connection.on('PinnedProductsUpdated', (args) => _emitPinnedProductsUpdated(args, 'PinnedProductsUpdated'));
  _connection.on('PinnedProductsChanged', (args) => _emitPinnedProductsUpdated(args, 'PinnedProductsChanged'));
  _connection.on('PinnedUpdated', (args) => _emitPinnedProductsUpdated(args, 'PinnedUpdated'));

    void _emitProductAdded(List<Object?>? args, String evt) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      onProductAdded?.call(payload);
      // onStatusChanged?.call('🟢 Sản phẩm được thêm ($evt)'); // Tắt log để tránh spam
    }
    _connection.on('ProductAddedToLivestream', (args) => _emitProductAdded(args, 'ProductAddedToLivestream'));

    void _emitProductRemoved(List<Object?>? args, String evt) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      onProductRemoved?.call(payload);
      // onStatusChanged?.call('🔴 Sản phẩm bị xoá ($evt)'); // Tắt log để tránh spam
    }
    _connection.on('ProductRemovedFromLivestream', (args) => _emitProductRemoved(args, 'ProductRemovedFromLivestream'));

    void _emitProductUpdated(List<Object?>? args, String evt) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      onLivestreamProductUpdated?.call(payload);
      // onStatusChanged?.call('✏️ Sản phẩm được cập nhật ($evt)'); // Tắt log để tránh spam
    }
    _connection.on('LivestreamProductUpdated', (args) => _emitProductUpdated(args, 'LivestreamProductUpdated'));

    void _emitPinChanged(List<Object?>? args, String evt, {required bool isLiveVariant}) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      if (isLiveVariant) {
        onLivestreamProductPinStatusChanged?.call(payload);
      } else {
        onProductPinStatusChanged?.call(payload);
      }
      // onStatusChanged?.call('📌 Trạng thái pin thay đổi ($evt)'); // Tắt log để tránh spam
    }
    _connection.on('ProductPinStatusChanged', (args) => _emitPinChanged(args, 'ProductPinStatusChanged', isLiveVariant: false));
    _connection.on('LivestreamProductPinStatusChanged', (args) => _emitPinChanged(args, 'LivestreamProductPinStatusChanged', isLiveVariant: true));

    void _emitStockUpdated(List<Object?>? args, String evt, {required bool isLiveVariant}) {
      final payload = _decodeFirstArg(args);
      if (payload.isEmpty) return;
      if (isLiveVariant) {
        onLivestreamProductStockUpdated?.call(payload);
      } else {
        onProductStockUpdated?.call(payload);
      }
      // onStatusChanged?.call('📦 Stock sản phẩm thay đổi ($evt)'); // Tắt log để tránh spam
    }
    _connection.on('ProductStockUpdated', (args) => _emitStockUpdated(args, 'ProductStockUpdated', isLiveVariant: false));
    _connection.on('LivestreamProductStockUpdated', (args) => _emitStockUpdated(args, 'LivestreamProductStockUpdated', isLiveVariant: true));
  _connection.on('StockChanged', (args) => _emitStockUpdated(args, 'StockChanged', isLiveVariant: false));
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
          // onStatusChanged?.call("📊 Nhận viewer stats qua SignalR"); // Tắt log để tránh spam
        }
      } catch (e) {
        onError?.call("Lỗi xử lý viewer stats: $e");
      }
    });
    _connection.on("UserTyping", (args) {
      try {
        if (args != null && args.isNotEmpty) {
          final data = args[0];
          if (data is Map<String, dynamic>) {
            final userId = (data['UserId'] ?? data['userId']) as String?;
            final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool?;
            
            if (userId != null && isTyping != null) {
              onUserTyping?.call(userId, isTyping);
              // onStatusChanged?.call("👤 User $userId ${isTyping ? 'đang gõ' : 'dừng gõ'}"); // Tắt log để tránh spam
            }
          }
        }
      } catch (e) {
        onError?.call("Lỗi xử lý typing indicator: $e");
      }
    });
    _connection.on("UserJoined", (args) {
      try {
        if (args != null && args.isNotEmpty) {
          final data = args[0];
          if (data is Map<String, dynamic>) {
            final userId = (data['UserId'] ?? data['userId']) as String?;
            final userName = (data['UserName'] ?? data['userName']) as String?;
            
            if (userId != null && !suppressPresenceDisplay) {
              onUserJoinedRoom?.call(userId, userName);
              // onStatusChanged?.call("👤 User $userId joined room"); // Tắt log để tránh spam
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
            final userId = (data['UserId'] ?? data['userId']) as String?;
            final userName = (data['UserName'] ?? data['userName']) as String?;
            
            if (userId != null && !suppressPresenceDisplay) {
              onUserLeftRoom?.call(userId, userName);
              // onStatusChanged?.call("👤 User $userId left room"); // Tắt log để tránh spam
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

  // Product-related
  onPinnedProductsUpdated = null;
  onProductAdded = null;
  onProductRemoved = null;
  onLivestreamProductUpdated = null;
  onProductPinStatusChanged = null;
  onLivestreamProductPinStatusChanged = null;
  onProductStockUpdated = null;
  onLivestreamProductStockUpdated = null;
  }

  Future<void> dispose() async {
    removeListeners();
    if (_isConnected) {
      await disconnect();
    }
    onStatusChanged?.call("SignalR service đã được dispose");
  }

//   bool _looksLikeJoinPresenceMessage(Map<String, dynamic> message) {
//     try {
//       final text = (message['text'] ?? message['message'] ?? message['content'] ?? message['body'] ?? '').toString().toLowerCase();
//       if (text.isEmpty) return false;
//       // Vietnamese phrases and generic English variants commonly used
//       const patterns = [
//         // 'đã tham gia livestream',
//         'đã tham gia phòng',
//         'joined the livestream',
//         'joined the room',
//         'has joined',
//       ];
//       for (final p in patterns) {
//         if (text.contains(p)) return true;
//       }
//     } catch (_) {}
//     return false;
//   }
}