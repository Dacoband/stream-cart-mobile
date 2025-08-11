import 'package:flutter/material.dart';

import '../../../presentation/blocs/livestream/livestream_state.dart';
import 'livestream_player.dart';
import 'status_pill.dart';

class VideoSection extends StatelessWidget {
  final LiveStreamLoaded state;
  const VideoSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Positioned.fill(
            child: LiveStreamPlayer(videoTrack: state.primaryVideoTrack),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: StatusPill(
              text: state.isConnectedRoom
                  ? 'LIVE'
                  : state.isConnectingRoom
                      ? 'Đang kết nối...'
                      : 'Đang chuẩn bị',
              color: state.isConnectedRoom
                  ? Colors.redAccent
                  : state.isConnectingRoom
                      ? Colors.orange
                      : Colors.grey,
            ),
          ),
          if (state.isJoining)
            const Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black38),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
