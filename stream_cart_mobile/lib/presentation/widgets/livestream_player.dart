import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

/// Simple player widget that renders the primary remote video track.
class LiveStreamPlayer extends StatefulWidget {
  final VideoTrack? videoTrack;
  final double aspectRatio;
  const LiveStreamPlayer({super.key, required this.videoTrack, this.aspectRatio = 16 / 9});

  @override
  State<LiveStreamPlayer> createState() => _LiveStreamPlayerState();
}

class _LiveStreamPlayerState extends State<LiveStreamPlayer> {
  VideoTrack? _attached;

  @override
  void didUpdateWidget(covariant LiveStreamPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoTrack?.sid != widget.videoTrack?.sid) {
      _attached = widget.videoTrack;
    }
  }

  @override
  void initState() {
    super.initState();
    _attached = widget.videoTrack;
  }

  @override
  Widget build(BuildContext context) {
    final track = _attached;
    if (track == null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: Colors.black12),
          child: Center(child: Icon(Icons.videocam_off, color: Colors.white54, size: 48)),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: VideoTrackRenderer(
        track,
        mirrorMode: VideoViewMirrorMode.auto,
      ),
    );
  }
}
