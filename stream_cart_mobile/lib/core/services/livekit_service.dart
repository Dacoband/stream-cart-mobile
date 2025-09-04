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

  Future<void> connect({required String url, required String token, bool forceRelay = false, bool isViewer = true}) async {
    await disconnect();
    _ensureConfigured();
    
    // Cấu hình room options khác nhau cho viewer và host
    RoomOptions roomOptions;
    if (isViewer) {
      // Viewer-only mode: disable tất cả local publishing
      roomOptions = const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultCameraCaptureOptions: CameraCaptureOptions(
          maxFrameRate: 0, // Disable camera capture hoàn toàn
        ),
        defaultAudioCaptureOptions: AudioCaptureOptions(
          noiseSuppression: false,
          echoCancellation: false,
          autoGainControl: false,
        ),
      );
    } else {
      // Host mode: enable normal publishing
      roomOptions = const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      );
    }
    
    final connectOptions = const ConnectOptions(
      autoSubscribe: true,
    );
    
    final room = Room(roomOptions: roomOptions);
    _room = room;
    _listenRoomEvents(isViewer);
    
    try {
      await room.connect(url, token, connectOptions: connectOptions);
      
      // Chỉ enforce viewer-only mode nếu là viewer
      if (isViewer) {
        await _ensureViewerOnlyMode();
        _startViewerOnlyModeWatcher();
      }
      
    } catch (e) {
      rethrow;
    }
  }

  void _listenRoomEvents([bool isViewer = true]) {
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
      
      // Chỉ enforce viewer-only mode nếu là viewer
      if (isViewer && event is TrackPublishedEvent && event.participant is LocalParticipant) {
        // Nếu local participant vô tình publish track, unpublish ngay
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

  /// Đảm bảo camera và mic luôn tắt cho viewer (chỉ xem và nghe)
  Future<void> _ensureViewerOnlyMode() async {
    final room = _room;
    if (room == null) return;
    
    try {
      final localParticipant = room.localParticipant;
      if (localParticipant == null) return;
      
      // Tắt hoàn toàn camera và mic
      await localParticipant.setMicrophoneEnabled(false);
      await localParticipant.setCameraEnabled(false);
      
      // Unpublish tất cả local tracks nếu có
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
      
      // Stop và dispose tất cả local tracks
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
      // Ignore errors but ensure viewer-only mode
    }
  }
}
