import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/di/dependency_injection.dart';
import '../../blocs/livestream/livestream_bloc.dart';
import '../../blocs/livestream/livestream_event.dart';
import '../../blocs/livestream/livestream_state.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class LiveStreamListPage extends StatelessWidget {
  final String? shopId;
  const LiveStreamListPage({super.key, this.shopId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LiveStreamBloc>()..add(_initialEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Livestream đang phát')),
        body: BlocBuilder<LiveStreamBloc, LiveStreamState>(
          builder: (context, state) {
            if (state is LiveStreamListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LiveStreamListError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<LiveStreamBloc>().add(_initialEvent()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            if (state is LiveStreamListLoaded) {
              if (state.liveStreams.isEmpty) {
                return const Center(child: Text('Chưa có livestream'));
              }
              final streams = state.liveStreams;
              return RefreshIndicator(
                onRefresh: () async { context.read<LiveStreamBloc>().add(_initialEvent()); },
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: streams.length,
                  itemBuilder: (context, index) {
                    final ls = streams[index];
                    return _LiveStreamCard(liveStream: ls, onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.livestreamDetail,
                        arguments: {'liveStreamId': ls.id},
                      );
                    });
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (i) {
            if (i == 0) return;
            if (i == 1) {
              Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (r) => false);
            } else if (i == 2) {
              Navigator.pushNamedAndRemoveUntil(context, AppRouter.profile, (r) => false);
            }
          },
        ),
      ),
    );
  }

  LiveStreamEvent _initialEvent() {
    if (shopId != null) return LoadLiveStreamsByShopEvent(shopId!);
  return LoadActiveLiveStreamsEvent();
  }
}

class _LiveStreamCard extends StatelessWidget {
  final dynamic liveStream;
  final VoidCallback onTap;
  const _LiveStreamCard({required this.liveStream, required this.onTap});

  String _formatViewer(int v) {
    if (v < 1000) return v.toString();
    if (v < 1000000) return (v / 1000).toStringAsFixed(1).replaceAll('.0', '') + 'k';
    return (v / 1000000).toStringAsFixed(1).replaceAll('.0', '') + 'm';
  }

  @override
  Widget build(BuildContext context) {
    final thumb = liveStream.thumbnailUrl as String?;
    final isLive = liveStream.isLive as bool? ?? false;
    final viewers = liveStream.currentViewerCount as int? ?? 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              height: 110,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: thumb != null && thumb.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: thumb,
                              fit: BoxFit.cover,
                              placeholder: (c, _) => Container(color: Colors.grey.shade200),
                              errorWidget: (c, _, __) => Container(color: Colors.grey.shade300, child: const Icon(Icons.image, color: Colors.grey)),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFE53935), Color(0xFFEC407A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 42),
                              ),
                            ),
                    ),
                  ),
                  if (isLive)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove_red_eye, size: 11, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            _formatViewer(viewers),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liveStream.title as String? ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      liveStream.shopName as String? ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
