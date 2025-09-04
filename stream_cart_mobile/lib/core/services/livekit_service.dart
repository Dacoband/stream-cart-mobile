import 'dart:async';
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
    try {
      await room.connect(url, token, connectOptions: connectOptions);
      
      // Explicitly ensure no local tracks are published - chỉ xem và nghe thôi
      // Disable any potential auto-publish of camera/mic
      await room.localParticipant?.setMicrophoneEnabled(false);
      await room.localParticipant?.setCameraEnabled(false);
      
      // Đảm bảo viewer-only mode
      await _ensureViewerOnlyMode();
      
  } catch (e) {
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
      if (event is RoomDisconnectedEvent) {
        _lastDisconnect = event;
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

  /// Đảm bảo camera và mic luôn tắt cho viewer (chỉ xem và nghe)
  Future<void> _ensureViewerOnlyMode() async {
    final room = _room;
    if (room == null) return;
    
    try {
      // Tắt hoàn toàn camera và mic cho viewer
      await room.localParticipant?.setMicrophoneEnabled(false);
      await room.localParticipant?.setCameraEnabled(false);
      
      // Stop tất cả local tracks để đảm bảo không publish
      final localParticipant = room.localParticipant;
      if (localParticipant != null) {
        // Stop tất cả video tracks
        for (final track in localParticipant.videoTrackPublications) {
          try {
            await track.track?.stop();
          } catch (_) {}
        }
        // Stop tất cả audio tracks
        for (final track in localParticipant.audioTrackPublications) {
          try {
            await track.track?.stop();
          } catch (_) {}
        }
      }
    } catch (_) {
      // Ignore errors but ensure viewer-only mode
    }
  }
}
