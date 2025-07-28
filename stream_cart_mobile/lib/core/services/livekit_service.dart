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


  LivekitService(
    this._chatRepository,
    {
      this.maxRetry = 3,
      this.retryDelay = const Duration(seconds: 2),
      this.onStatusChanged,
    }
  );

  Future<void> initializeRoom({
    required String chatRoomId,
    required String userId,
    required String userName,
    bool isReconnect = false,
    }) async {
      // Nếu đang kết nối phòng khác thì disconnect trước
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
        final result = await _chatRepository.getShopToken(chatRoomId);
        final token = result.fold(
          (failure) => throw Exception('Lỗi khi lấy token: ${failure.message}'),
          (token) => token,
        );

        if (_room == null || isReconnect) {
          _room = Room();
          _setupListeners();
        }

        print('LiveKit URL: $url');
        print('LiveKit Token: $token');
        print('Connecting to LiveKit as user: $userName');

        await _room!.connect(url, token, connectOptions: ConnectOptions(autoSubscribe: true));
        _isConnected = true;
        _currentRetry = 0; // Reset khi kết nối thành công
        print('Đã kết nối thành công đến LiveKit tại $url với user: $userName');
        onStatusChanged?.call('Đã kết nối');
        return;
      } catch (e) {
        _isConnected = false;
        print('Lỗi kết nối đến LiveKit: $e');
        onStatusChanged?.call('Lỗi kết nối: $e');
        if (e.toString().contains('404') || e.toString().contains('token') || e.toString().contains('401') || e.toString().contains('403')) {
          retryCount++;
          _currentRetry = retryCount;
          if (retryCount < maxRetry) {
            await Future.delayed(retryDelay);
            print('Thử kết nối lại lần $retryCount...');
            continue;
          }
        }
        _currentRetry = 0; // Reset khi hết retry
        rethrow;
      }
    }
    onStatusChanged?.call('Kết nối thất bại sau $maxRetry lần thử');
    throw Exception('Kết nối thất bại sau $maxRetry lần thử');
  }

  void _setupListeners() {
    _room!.events.listen((event) async {
      if (event is RoomConnectedEvent) {
        _isConnected = true;
        _currentRetry = 0;
        print('Đã kết nối đến phòng: ${_room!.name}');
        onStatusChanged?.call('Đã kết nối');
      } else if (event is RoomDisconnectedEvent) {
        _isConnected = false;
        print('Ngắt kết nối khỏi phòng: ${_room!.name} do ${event.reason}');
        onStatusChanged?.call('Đã ngắt kết nối, thử kết nối lại...');

        if (_chatRoomId != null &&
            _userId != null &&
            _userName != null &&
            _currentRetry < maxRetry &&
            event.reason != DisconnectReason.participantRemoved &&
            !event.reason.toString().contains('error') &&
            event.reason != DisconnectReason.duplicateIdentity &&
            event.reason != DisconnectReason.joinFailure) {
          _currentRetry++;
          try {
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
      } else if (event is ParticipantConnectedEvent) {
        print('Participant joined: ${event.participant.identity} (${event.participant.name})');
      } else if (event is ParticipantDisconnectedEvent) {
        print('Participant left: ${event.participant.identity} (${event.participant.name})');
      } else if (event is DataReceivedEvent) {
        final messageStr = String.fromCharCodes(event.data);
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

  Future<void> disconnect() async {
    if (_isConnected) {
      await _room?.disconnect();
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
    if (!_isConnected) return false;
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

  ChatBloc? _chatBloc;

  void setChatBloc(ChatBloc chatBloc) {
    _chatBloc = chatBloc;
  }
}