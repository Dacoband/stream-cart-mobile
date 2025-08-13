import 'package:flutter/material.dart';
import '../../blocs/livestream/livestream_state.dart';

class InfoBar extends StatelessWidget {
  final LiveStreamLoaded state;
  const InfoBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final ls = state.liveStream;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(radius: 18, child: Icon(Icons.store)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ls.title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  ls.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.remove_red_eye, size: 16),
              const SizedBox(width: 4),
              Text('${state.viewerCount ?? state.participants.length}'),
            ],
          ),
        ],
      ),
    );
  }
}
