import 'dart:typed_data';

import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_cart_mobile/domain/repositories/chat_repository.dart';
import 'package:stream_cart_mobile/core/error/failures.dart';

class LivekitService {
  late final Room _room;
  bool _isConnected = false;
  final ChatRepository _chatRepository;

  LivekitService(this._chatRepository);

  Future<void> initializeRoom({
    required String chatRoomId,
    required String userId,
    required String userName,
  }) async {
      if (_isConnected) {
        print('Đã kết nối, không cần khởi tạo lại.');
        return;
      }

      await dotenv.load();
      final url = dotenv.env['LIVEKIT_URL'];
      if (url == null || url.isEmpty) {
        throw Exception('LIVEKIT_URL không được thiết lập trong .env');
      }

      final result = await _chatRepository.getShopToken(chatRoomId);
      final token = result.fold(
        (failure) {
          if (failure is UnauthorizedFailure) {
            throw Exception('Lỗi xác thực: Vui lòng đăng nhập lại');
          } else if (failure is NetworkFailure) {
            throw Exception('Lỗi mạng: ${failure.message}');
          } else {
            throw Exception('Lỗi khi lấy token: ${failure.message}');
          }
        },
        (token) => token,
      );

      _room = Room();
      _setupListeners();

      try {
        await _room.connect(
          url,
          token,
          connectOptions: ConnectOptions(autoSubscribe: true),
        );
        _isConnected = true;
        print('Đã kết nối thành công đến LiveKit tại $url với user: $userName');
      } catch (e) {
        _isConnected = false;
        print('Lỗi kết nối đến LiveKit: $e');
        rethrow;
      }
    }

  void _setupListeners() {
  _room.events.listen((event) {
    if (event is RoomConnectedEvent) {
      _isConnected = true;
      print('Đã kết nối đến phòng: ${_room.name}');
    } else if (event is RoomDisconnectedEvent) {
      _isConnected = false;
      print('Ngắt kết nối khỏi phòng: ${_room.name}');
    } else if (event is ParticipantConnectedEvent) {
      print('Participant joined: ${event.participant.identity} (${event.participant.name})');
    } else if (event is ParticipantDisconnectedEvent) {
      print('Participant left: ${event.participant.identity} (${event.participant.name})');
    } else if (event is DataReceivedEvent) {
      print('Nhận dữ liệu: ${String.fromCharCodes(event.data)} từ ${event.participant?.identity}');
    }
  });
}

  /// Disconnects from the LiveKit room.
  Future<void> disconnect() async {
    if (_isConnected) {
      await _room.disconnect();
      _isConnected = false;
      print('Đã ngắt kết nối khỏi LiveKit');
    } else {
      print('Chưa kết nối, không cần ngắt kết nối.');
    }
  }


  Future<bool> sendDataMessage(String message) async {
    if (!_isConnected) return false;
    try {
      await _room.localParticipant?.publishData(
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

  Room get room => _room;
}