import 'dart:typed_data';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_cart_mobile/domain/repositories/chat_repository.dart';
import 'package:stream_cart_mobile/presentation/blocs/chat/chat_bloc.dart';
import '../../presentation/blocs/chat/chat_event.dart';

class LivekitService {
  Room? _room;
  bool _isConnected = false;
  final ChatRepository _chatRepository;

  String? _chatRoomId;
  String? _userId;
  String? _userName;

  final int maxRetry;
  final Duration retryDelay;
  int _currentRetry = 0;

  void Function(String status)? onStatusChanged;
  ChatBloc? _chatBloc;

  LivekitService(
    this._chatRepository, {
    this.maxRetry = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.onStatusChanged,
  });

  Future<void> initializeRoom({
    required String chatRoomId,
    required String userId,
    required String userName,
    bool isReconnect = false,
  }) async {
    // Nếu đang kết nối đúng phòng thì không cần connect lại
    if (_isConnected && _chatRoomId == chatRoomId && !isReconnect) {
      print('Đã kết nối đúng phòng, không cần connect lại.');
      return;
    }
    
    // Nếu đang kết nối phòng khác thì disconnect trước
    if (_isConnected && _chatRoomId != null && _chatRoomId != chatRoomId) {
      await disconnect();
    }

    _chatRoomId = chatRoomId;
    _userId = userId;
    _userName = userName;

    if (_isConnected && !isReconnect) {
      print('Đã kết nối, không cần khởi tạo lại.');
      return;
    }

    await dotenv.load();
    final url = dotenv.env['LIVEKIT_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('LIVEKIT_URL không được thiết lập trong .env');
    }

    int retryCount = isReconnect ? _currentRetry : 0;
    while (retryCount < maxRetry) {
      try {
        onStatusChanged?.call(isReconnect ? 'Đang kết nối lại...' : 'Đang kết nối...');
        
        // Tạo timestamp unique để tránh duplicate identity
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        print('🔄 Requesting token for userId: $_userId, timestamp: $timestamp');
        
        final result = await _chatRepository.getShopToken(
          chatRoomId, 
          userId: _userId!, 
          timestamp: timestamp,
        );
        final token = result.fold(
          (failure) => throw Exception('Lỗi khi lấy token: ${failure.message}'),
          (token) => token,
        );

        // Tạo room mới và setup listeners
        if (_room == null || isReconnect) {
          _room = Room();
          _setupListeners();
        }

        print('LiveKit URL: $url');
        print('LiveKit Token: ${token.substring(0, 50)}...');
        print('Connecting to LiveKit as user: $userName (userId: $_userId)');

        await _room!.connect(url, token, connectOptions: ConnectOptions(autoSubscribe: true));
        _isConnected = true;
        _currentRetry = 0;
        print('Đã kết nối thành công đến LiveKit tại $url với user: $userName');
        onStatusChanged?.call('Đã kết nối');
        return;
      } catch (e) {
        _isConnected = false;
        print('Lỗi kết nối đến LiveKit: $e');
        onStatusChanged?.call('Lỗi kết nối: $e');
        
        // Retry cho một số loại lỗi specific
        if (e.toString().contains('404') || 
            e.toString().contains('token') || 
            e.toString().contains('401') || 
            e.toString().contains('403')) {
          retryCount++;
          _currentRetry = retryCount;
          if (retryCount < maxRetry) {
            await Future.delayed(retryDelay);
            print('Thử kết nối lại lần $retryCount...');
            continue;
          }
        }
        _currentRetry = 0;
        rethrow;
      }
    }
    
    onStatusChanged?.call('Kết nối thất bại sau $maxRetry lần thử');
    throw Exception('Kết nối thất bại sau $maxRetry lần thử');
  }

  // Chỉ sử dụng 1 cách setup listeners - event stream
  void _setupListeners() {
    _room!.events.listen((event) async {
      if (event is RoomConnectedEvent) {
        _isConnected = true;
        _currentRetry = 0;
        print('✅ Đã kết nối đến phòng: ${_room!.name}');
        onStatusChanged?.call('✅ Đã kết nối tới LiveKit');
      } else if (event is RoomDisconnectedEvent) {
        _isConnected = false;
        final reason = event.reason;
        print('🔴 Ngắt kết nối khỏi phòng: ${_room!.name} do $reason');
        
        // Xử lý các trường hợp disconnect
        if (reason == DisconnectReason.duplicateIdentity) {
          print('⚠️ DUPLICATE IDENTITY DETECTED! Backend chưa fix unique identity!');
          onStatusChanged?.call('❌ Duplicate Identity - Backend cần fix!');
          return;
        }
        
        if (reason == DisconnectReason.joinFailure) {
          print('🔴 Join failure detected - triggering reconnect');
          onStatusChanged?.call('🔴 Ngắt kết nối: DisconnectReason.joinFailure');
        } else {
          onStatusChanged?.call('🔴 Ngắt kết nối: $reason');
        }

        // Auto-reconnect cho một số trường hợp
        if (_shouldReconnect(reason)) {
          onStatusChanged?.call('🔄 Đang kết nối lại...');
          _currentRetry++;
          
          if (_currentRetry <= maxRetry) {
            try {
              await Future.delayed(retryDelay * _currentRetry);
              await initializeRoom(
                chatRoomId: _chatRoomId!,
                userId: _userId!,
                userName: _userName!,
                isReconnect: true,
              );
            } catch (e) {
              print('Reconnect thất bại: $e');
              onStatusChanged?.call('Reconnect thất bại: $e');
            }
          } else {
            _currentRetry = 0;
            onStatusChanged?.call('Kết nối thất bại sau $maxRetry lần thử');
          }
        } else {
          _currentRetry = 0;
        }
      } else if (event is ParticipantConnectedEvent) {
        print('👋 Participant joined: ${event.participant.identity} (${event.participant.name})');
      } else if (event is ParticipantDisconnectedEvent) {
        print('👋 Participant left: ${event.participant.identity} (${event.participant.name})');
      } else if (event is DataReceivedEvent) {
        final messageStr = String.fromCharCodes(event.data);
        print('📨 LiveKit message received from ${event.participant?.identity}: $messageStr');
        
        // Gửi event cho ChatBloc nếu đã set
        _chatBloc?.add(ReceiveMessage(
          messageStr,
          event.participant?.identity ?? '',
          _chatRoomId ?? '',
          event.participant?.name ?? '',
          false,
        ));
      }
    });
  }

  // Helper method để quyết định có nên reconnect không
  bool _shouldReconnect(DisconnectReason? reason) {
    if (_chatRoomId == null || _userId == null || _userName == null) {
      return false;
    }

    // Không reconnect cho những trường hợp này
    const noReconnectReasons = [
      DisconnectReason.duplicateIdentity,
      DisconnectReason.participantRemoved,
    ];

    if (reason != null && noReconnectReasons.contains(reason)) {
      return false;
    }

    // Reconnect cho joinFailure và network issues
    return true;
  }

  Future<void> disconnect() async {
    if (_isConnected && _room != null) {
      await _room!.disconnect();
      _isConnected = false;
      _chatRoomId = null;
      _userId = null;
      _userName = null;
      _currentRetry = 0;
      print('Đã ngắt kết nối khỏi LiveKit');
    } else {
      print('Chưa kết nối, không cần ngắt kết nối.');
    }
  }

  Future<bool> sendDataMessage(String message) async {
    if (!_isConnected || _room == null) return false;
    try {
      await _room!.localParticipant?.publishData(
        Uint8List.fromList(message.codeUnits),
        reliable: true,
        destinationIdentities: null,
      );
      print('Đã gửi tin nhắn: $message');
      return true;
    } catch (e) {
      print('Lỗi khi gửi tin nhắn: $e');
      return false;
    }
  }

  bool get isConnected => _isConnected;
  Room? get room => _room;

  void setChatBloc(ChatBloc chatBloc) {
    _chatBloc = chatBloc;
  }
}