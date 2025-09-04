import 'dart:async';
import 'dart:convert';
import 'package:signalr_core/signalr_core.dart';
import 'storage_service.dart';

// Match TypeScript ReceiveMessagePayload structure
class ReceiveMessagePayload {
  final String? messageId;
  final String? chatRoomId;
  final String? senderId;
  final String? senderName;
  final String? message;
  final String? content;
  final String? timestamp;
  final bool? isTyping;

  ReceiveMessagePayload({
    this.messageId,
    this.chatRoomId,
    this.senderId,
    this.senderName,
    this.message,
    this.content,
    this.timestamp,
    this.isTyping,
  });

  factory ReceiveMessagePayload.fromMap(Map<String, dynamic> map) {
    return ReceiveMessagePayload(
      messageId: map['messageId']?.toString(),
      chatRoomId: map['chatRoomId']?.toString(),
      senderId: map['senderId']?.toString(),
      senderName: map['senderName']?.toString(),
      message: map['message']?.toString(),
      content: map['content']?.toString(),
      timestamp: map['timestamp']?.toString(),
      isTyping: map['isTyping'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'content': content,
      'timestamp': timestamp,
      'isTyping': isTyping,
    };
  }
}

class SignalRChatClient {
  final String baseUrl;
  final StorageService _storageService;
  String? _accessToken;
  HubConnection? _connection;
  bool isConnected = false;
  
  // Guard concurrent starts (similar to React StrictMode protection)
  Completer<void>? _starting;

  // Event callbacks
  void Function(ReceiveMessagePayload data)? onReceiveMessage;
  void Function(Map<String, dynamic> data)? onUserJoined;
  void Function(Map<String, dynamic> data)? onUserLeft;
  void Function(Map<String, dynamic> data)? onUserTyping;
  void Function(Map<String, dynamic> data)? onConnected;
  void Function(ReceiveMessagePayload data)? onReceiveChatMessage;
  void Function(dynamic error)? onError;
  void Function(Exception? error)? onReconnecting;
  void Function(String? connectionId)? onReconnected;
  void Function(Exception? error)? onConnectionClosed;

  SignalRChatClient({
    required this.baseUrl,
    required StorageService storageService,
    String? accessToken,
  }) : _storageService = storageService, _accessToken = accessToken;

  // Helper methods for connection state
  HubConnectionState _getState() {
    return _connection?.state ?? HubConnectionState.disconnected;
  }

  bool _isConnectedState(HubConnectionState state) {
    return state == HubConnectionState.connected;
  }

  bool _isStableState(HubConnectionState state) {
    return state == HubConnectionState.connected || 
           state == HubConnectionState.disconnected;
  }

  String? _normalizeToken(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final s = raw.replaceAll(RegExp(r'^"|"$'), '').trim();
      // Strip optional Bearer prefix if present
      return s.replaceAll(RegExp(r'^(?:Bearer\s+)', caseSensitive: false), '');
    } catch (e) {
      return null;
    }
  }

  Future<HubConnection> _buildConnection() async {
    // Backend exposes SignalR hub at '/signalrchat' (not under /api)
    final apiBase = baseUrl.replaceAll(RegExp(r'/$'), '');
    final signalRBase = apiBase.replaceAll(RegExp(r'/api/?$', caseSensitive: false), '');
    
    // Get access token
    final accessToken = _normalizeToken(
      _accessToken ?? await _storageService.getAccessToken()
    );
    
    // Build URL with query parameters like frontend web
    final hubUrl = '$signalRBase/signalrchat?access_token=$accessToken';
    

    return HubConnectionBuilder()
        .withUrl(
          hubUrl,
          HttpConnectionOptions(
            transport: HttpTransportType.webSockets,
            skipNegotiation: false,
            withCredentials: false,
          ),
        )
        .withAutomaticReconnect([0, 2000, 10000, 30000])
        .build();
  }

  Future<bool> initializeConnection([String? token]) async {
    if (token != null) _accessToken = token;
    
    // Create connection lazily
    _connection ??= await _buildConnection();
    _setupEventHandlers();

    // Already connected
    if (_isConnectedState(_getState())) {
      isConnected = true;
      return true;
    }

    // Start already in progress — await the same completer
    if (_starting != null && !_starting!.isCompleted) {
      try {
        await _starting!.future;
        isConnected = _connection?.state == HubConnectionState.connected;
        return isConnected;
  } catch (err) {
        isConnected = false;
        return false;
      }
    }

    // Kick off a single start attempt
    _starting = Completer<void>();
    
    try {
      await _performStart();
      isConnected = _isConnectedState(_getState());
      _starting!.complete();
      return isConnected;
    } catch (e) {
      if (!_starting!.isCompleted) _starting!.completeError(e);
      rethrow;
    } finally {
      _starting = null;
    }
  }

  Future<void> _performStart() async {
    // If currently disconnecting/reconnecting/connecting, wait a tick
    if (_connection != null && !_isStableState(_getState())) {
      int spins = 0;
      while (!_isStableState(_getState()) && spins < 30) {
        await Future.delayed(const Duration(milliseconds: 100));
        spins++;
      }
      if (_isConnectedState(_getState())) return; // Someone else connected
    }

    // If connection object was disposed, rebuild
    if (_connection == null) {
      _connection = await _buildConnection();
      _setupEventHandlers();
    }

    try {
      await _connection!.start();
    } catch (err) {
      
      // Quick single retry after short delay
      await Future.delayed(const Duration(milliseconds: 400));
      try {
        await _connection!.start();
      } catch (e2) {
        rethrow;
      }
    }
  }

  void _setupEventHandlers() {
    if (_connection == null) return;

    // Clear previous handlers to avoid duplicates
    try { _connection!.off('ReceiveChatMessage'); } catch (e) { /* ignore */ }
    try { _connection!.off('UserJoined'); } catch (e) { /* ignore */ }
    try { _connection!.off('UserLeft'); } catch (e) { /* ignore */ }
    try { _connection!.off('UserTyping'); } catch (e) { /* ignore */ }
    try { _connection!.off('Connected'); } catch (e) { /* ignore */ }
    try { _connection!.off('Error'); } catch (e) { /* ignore */ }

    _connection!.on('ReceiveChatMessage', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = _parseMessageData(arguments[0]);
        final payload = ReceiveMessagePayload.fromMap(data);
        onReceiveMessage?.call(payload);
        onReceiveChatMessage?.call(payload);
      } else {
      }
    });

    // Optional server confirmation that connection is established
    _connection!.on('Connected', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = _parseGenericData(arguments[0]);
        onConnected?.call(data);
      }
    });

    _connection!.on('UserJoined', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = _parseGenericData(arguments[0]);
        onUserJoined?.call(data);
      }
    });

    _connection!.on('UserLeft', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = _parseGenericData(arguments[0]);
        onUserLeft?.call(data);
      }
    });

    _connection!.on('UserTyping', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = _parseGenericData(arguments[0]);
        onUserTyping?.call(data);
      }
    });

    // Connection lifecycle events
  _connection!.onreconnecting((Exception? error) {
      isConnected = false;
      onReconnecting?.call(error);
    });

  _connection!.onreconnected((String? connectionId) {
      isConnected = true;
      onReconnected?.call(connectionId);
    });

  _connection!.onclose((Exception? error) {
      isConnected = false;
      onConnectionClosed?.call(error);
    });

    // Global error event from server hub
    _connection!.on('Error', (List<Object?>? arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final error = arguments[0];
        onError?.call(error);
      }
    });
  }

  Map<String, dynamic> _parseMessageData(Object? data) {
    Map<String, dynamic> result = <String, dynamic>{};
    
    if (data is Map<String, dynamic>) {
      result = data;
    } else if (data is Map) {
      result = Map<String, dynamic>.from(data);
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          result = Map<String, dynamic>.from(decoded);
        }
  } catch (e) {
      }
    }
    
    // Ensure standard ReceiveMessagePayload structure
    return {
      'messageId': result['messageId']?.toString(),
      'chatRoomId': result['chatRoomId']?.toString(),
      'senderId': result['senderId']?.toString(),
      'senderName': result['senderName']?.toString(),
      'message': result['message']?.toString(),
      'content': result['content']?.toString(),
      'timestamp': result['timestamp']?.toString(),
      'isTyping': result['isTyping'] as bool?,
    };
  }

  Map<String, dynamic> _parseGenericData(Object? data) {
    return _parseMessageData(data);
  }

  Future<void> _ensureConnected() async {
    await initializeConnection();
  }

  Future<bool> joinChatRoom(String chatRoomId) async {
    await _ensureConnected();
  if (_connection == null || !_isConnectedState(_getState())) {
      return false;
    }

  try {
      await _connection!.invoke('JoinDirectChatRoom', args: [chatRoomId]);
      
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> leaveChatRoom(String chatRoomId) async {
    if (_connection == null || !isConnected) return;
    
    try {
      await _connection!.invoke('LeaveDirectChatRoom', args: [chatRoomId]);
    } catch (err) {
      }
  }

  Future<bool> sendMessage(String chatRoomId, String message) async {
    if (_connection == null || !isConnected) return false;
    
  try {
      await _connection!.invoke('SendMessageToChatRoom', args: [chatRoomId, message]);
      
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> setTypingStatus(String chatRoomId, bool isTyping) async {
    if (_connection == null || !isConnected) return;
    
    try {
      await _connection!.invoke('SetTypingStatus', args: [chatRoomId, isTyping]);
    } catch (err) {
    }
  }

  Future<void> disconnect() async {
    if (_connection == null) return;
    
    try {
      // Avoid calling stop while a start is in-flight
      if (_starting != null && !_starting!.isCompleted) {
        try {
          await _starting!.future;
        } catch (e) {
          // ignore
        }
      }
      
      await _connection!.stop();
    } catch (e) {
      // ignore
    } finally {
      isConnected = false;
      _connection = null;
      _starting = null;
    }
  }

  // Utility method to update access token
  void updateToken(String? token) {
    _accessToken = token;
  }

  // Cleanup method
  void dispose() {
    disconnect();
    onReceiveMessage = null;
    onUserJoined = null;
    onUserLeft = null;
    onUserTyping = null;
    onConnected = null;
    onReceiveChatMessage = null;
    onError = null;
    onReconnecting = null;
    onReconnected = null;
    onConnectionClosed = null;
  }
}

// Global singleton instance (similar to the Next.js pattern)
SignalRChatClient? _signalRChatClientInstance;

SignalRChatClient getSignalRChatClient({
  required String baseUrl,
  required StorageService storageService,
  String? accessToken,
}) {
  _signalRChatClientInstance ??= SignalRChatClient(
    baseUrl: baseUrl,
    storageService: storageService,
    accessToken: accessToken,
  );
  return _signalRChatClientInstance!;
}
