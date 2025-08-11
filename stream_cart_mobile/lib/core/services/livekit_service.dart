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
      adaptiveStream: false,
      dynacast: false,
    );
    final room = Room(roomOptions: roomOptions);
    _room = room;
    _listenRoomEvents();
    await room.connect(url, token, connectOptions: const ConnectOptions(autoSubscribe: true));
  }

  void _listenRoomEvents() {
    _listener?.dispose();
    final room = _room;
    if (room == null) return;
    _listener = room.createListener();
    _listener!.on<RoomEvent>((event) {
      if (!_events.isClosed) _events.add(event);
      if (event is TrackPublishedEvent || event is ParticipantConnectedEvent) {
        forceSubscribeAll();
      }
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

  void forceSubscribeAll() {
    final r = _room;
    if (r == null) return;
    for (final p in r.remoteParticipants.values) {
      for (final pub in p.videoTrackPublications) {
        if (!pub.subscribed) {
          try { pub.subscribe(); } catch (_) {}
        }
      }
    }
  }
}
