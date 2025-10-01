import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  final _events = StreamController<RoomEvent>.broadcast();
  RoomDisconnectedEvent? _lastDisconnect;
  static bool _configured = false;
  bool _forceSubscribeRemote = true; // control forced subscription behavior

  Stream<RoomEvent> get events => _events.stream;
  Room? get room => _room;
  RoomDisconnectedEvent? get lastDisconnect => _lastDisconnect;

  Future<void> connect({required String url, required String token, bool forceRelay = false, bool isViewer = true, bool viewerSafeMode = false}) async {
    await disconnect();
    _ensureConfigured();
    
    // Debug: decode JWT to verify identity and grants (helps detect duplicate identity).
    try {
      final payload = _decodeJwtPayload(token);
      final identity = payload['sub'] ?? (payload['video'] is Map ? (payload['video']['identity'] ?? payload['video']['name']) : null);
      final grants = payload['video'];
      debugPrint('[LiveKit] Token identity: ${identity ?? 'unknown'} | grants.canPublish: ${grants is Map ? grants['canPublish'] : 'unknown'} | canSubscribe: ${grants is Map ? grants['canSubscribe'] : 'unknown'}');
    } catch (_) {
      // ignore decode errors
    }

    // Cấu hình room options khác nhau cho viewer và host
    RoomOptions roomOptions;
    if (isViewer) {
      // Viewer-only mode: disable tất cả local publishing.
      // viewerSafeMode: tắt adaptiveStream/dynacast để tránh ảnh hưởng publisher khi một số server/SDK xử lý aggressive dynacast.
      roomOptions = RoomOptions(
        adaptiveStream: viewerSafeMode ? false : true,
        dynacast: viewerSafeMode ? false : true,
        defaultCameraCaptureOptions: const CameraCaptureOptions(
          maxFrameRate: 0, // Disable camera capture hoàn toàn
        ),
        defaultAudioCaptureOptions: const AudioCaptureOptions(
          noiseSuppression: false,
          echoCancellation: false,
          autoGainControl: false,
        ),
      );
      _forceSubscribeRemote = !viewerSafeMode; // skip force-subscribe in safe mode
    } else {
      // Host mode: enable normal publishing
      roomOptions = const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      );
      _forceSubscribeRemote = true;
    }
    
    final connectOptions = const ConnectOptions(
      autoSubscribe: true,
    );
    
    final room = Room(roomOptions: roomOptions);
    _room = room;
  _listenRoomEvents(isViewer, viewerSafeMode: viewerSafeMode);
    
    try {
      await room.connect(url, token, connectOptions: connectOptions);
      if (isViewer) {
        await _ensureViewerOnlyMode();
        _startViewerOnlyModeWatcher();
      }
      
    } catch (e) {
      rethrow;
    }
  }

  // Decode JWT payload (best-effort, no signature verification)
  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) throw ArgumentError('Invalid JWT');
    String normalized(String s) {
      // Fix base64url padding
      switch (s.length % 4) {
        case 2:
          return s + '==';
        case 3:
          return s + '=';
        default:
          return s;
      }
    }
    final payload = utf8.decode(base64Url.decode(normalized(parts[1])));
    final map = jsonDecode(payload);
    if (map is Map<String, dynamic>) return map;
    return Map<String, dynamic>.from(map as Map);
  }

  void _listenRoomEvents(bool isViewer, {bool viewerSafeMode = false}) {
    _listener?.dispose();
    final room = _room;
    if (room == null) return;
    _listener = room.createListener();
    _listener!.on<RoomEvent>((event) {
      if (!_events.isClosed) _events.add(event);
      if (event is RoomDisconnectedEvent) {
        _lastDisconnect = event;
      }
      if (_forceSubscribeRemote && (event is TrackPublishedEvent || event is ParticipantConnectedEvent)) {
        forceSubscribeAll();
      }
      if (isViewer && event is TrackPublishedEvent && event.participant is LocalParticipant) {
        _ensureViewerOnlyMode();
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

  /// Kiểm tra định kỳ để đảm bảo viewer-only mode
  void _startViewerOnlyModeWatcher() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      final room = _room;
      if (room == null || room.connectionState != ConnectionState.connected) {
        timer.cancel();
        return;
      }
      
      final localParticipant = room.localParticipant;
      if (localParticipant != null) {
        // Kiểm tra nếu có tracks được publish, unpublish ngay
        if (localParticipant.videoTrackPublications.isNotEmpty ||
            localParticipant.audioTrackPublications.isNotEmpty) {
          _ensureViewerOnlyMode();
        }
      }
    });
  }

  Future<void> _ensureViewerOnlyMode() async {
    final room = _room;
    if (room == null) return;
    
    try {
      final localParticipant = room.localParticipant;
      if (localParticipant == null) return;
      // Tắt camera và mic
      await localParticipant.setMicrophoneEnabled(false);
      await localParticipant.setCameraEnabled(false);
      final videoTrackPubs = List.from(localParticipant.videoTrackPublications);
      for (final track in videoTrackPubs) {
        try {
          await track.unpublish();
        } catch (_) {}
      }
      
      final audioTrackPubs = List.from(localParticipant.audioTrackPublications);
      for (final track in audioTrackPubs) {
        try {
          await track.unpublish();
        } catch (_) {}
      }
      for (final track in videoTrackPubs) {
        try {
          await track.track?.stop();
          track.track?.dispose();
        } catch (_) {}
      }
      
      for (final track in audioTrackPubs) {
        try {
          await track.track?.stop();
          track.track?.dispose();
        } catch (_) {}
      }
      
    } catch (_) {
    }
  }
}
