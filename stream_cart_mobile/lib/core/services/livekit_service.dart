import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  final _events = StreamController<RoomEvent>.broadcast();
  RoomDisconnectedEvent? _lastDisconnect;
  static bool _configured = false;

  Stream<RoomEvent> get events => _events.stream;
  Room? get room => _room;
  RoomDisconnectedEvent? get lastDisconnect => _lastDisconnect;

  Future<void> connect({required String url, required String token, bool forceRelay = false}) async {
    await disconnect();
    _ensureConfigured();
    final roomOptions = const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
    );
    final connectOptions = const ConnectOptions(
      autoSubscribe: true,
    );
    final room = Room(roomOptions: roomOptions);
    _room = room;
    _listenRoomEvents();
    debugPrint('[LiveKitService] Connecting url=$url relay=${forceRelay ? 'relay-only' : 'all'}');
    try {
      await room.connect(url, token, connectOptions: connectOptions);
  debugPrint('[LiveKitService] Connected: localParticipant=${room.localParticipant?.identity}');
    } catch (e, st) {
      debugPrint('[LiveKitService] Connect error: $e\n$st');
      rethrow;
    }
  }

  void _listenRoomEvents() {
    _listener?.dispose();
    final room = _room;
    if (room == null) return;
    _listener = room.createListener();
    _listener!.on<RoomEvent>((event) {
      if (!_events.isClosed) _events.add(event);
      if (kDebugMode) {
        debugPrint('[LiveKitService] Event: ${event.runtimeType}');
        if (event is RoomDisconnectedEvent) {
          _lastDisconnect = event;
          debugPrint('[LiveKitService] Disconnected');
        } else if (event is TrackSubscribedEvent) {
          debugPrint('[LiveKitService] TrackSubscribed kind=${event.publication.kind} sid=${event.publication.sid}');
        }
      }
      if (event is TrackPublishedEvent || event is ParticipantConnectedEvent) {
        forceSubscribeAll();
      }
    });
  }

  List<RemoteParticipant> get remoteParticipants => _room?.remoteParticipants.values.toList() ?? [];

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
          try {
            pub.subscribe();
          } catch (_) {}
        }
      }
    }
  }

  void _ensureConfigured() {
    if (_configured) return;
  _configured = true;
  }
}
