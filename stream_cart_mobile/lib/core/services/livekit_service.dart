import 'dart:async';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  final _events = StreamController<RoomEvent>.broadcast();

  Stream<RoomEvent> get events => _events.stream;
  Room? get room => _room;

  Future<void> connect({required String url, required String token}) async {
    await disconnect();
    final roomOptions = const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
    );
  final room = Room(roomOptions: roomOptions);
  await room.connect(url, token);
  _room = room;
    _listenRoomEvents();
  }

  void _listenRoomEvents() {
    _listener?.dispose();
    final room = _room;
    if (room == null) return;
    _listener = room.createListener();
    _listener!.on<RoomEvent>((event) {
      if (!_events.isClosed) _events.add(event);
    });
  }

  List<RemoteParticipant> get remoteParticipants =>
      _room?.remoteParticipants.values.toList() ?? [];

  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
    } catch (_) {}
  _listener?.dispose();
  _listener = null;
    _room = null;
  }

  void dispose() {
  _listener?.dispose();
    _events.close();
  }
}
