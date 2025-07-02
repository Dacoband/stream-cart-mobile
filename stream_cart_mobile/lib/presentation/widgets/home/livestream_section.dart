import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class LiveStreamSection extends StatelessWidget {
  const LiveStreamSection({super.key});

  // Mock livestream data
  static const List<Map<String, dynamic>> _mockStreams = [
    {
      'id': '1',
      'title': 'Flash Sale Điện Thoại',
      'hostName': 'Tech Store',
      'viewerCount': 1234,
      'isLive': true,
      'thumbnailColor': Colors.red,
    },
    {
      'id': '2',
      'title': 'Thời Trang Xu Hướng',
      'hostName': 'Fashion Shop',
      'viewerCount': 856,
      'isLive': true,
      'thumbnailColor': Colors.pink,
    },
    {
      'id': '3',
      'title': 'Làm Đẹp Tại Nhà',
      'hostName': 'Beauty World',
      'viewerCount': 642,
      'isLive': true,
      'thumbnailColor': Colors.purple,
    },
  ];

  String _formatViewerCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Đang Live',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all livestreams
                },
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            itemCount: _mockStreams.length,
            itemBuilder: (context, index) {
              final stream = _mockStreams[index];
              return GestureDetector(
                onTap: () {
                  // TODO: Navigate to livestream detail
                  print('Stream tapped: ${stream['title']}');
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (stream['thumbnailColor'] as Color),
                              (stream['thumbnailColor'] as Color).withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white.withOpacity(0.8),
                                size: 40,
                              ),
                            ),
                            // Live badge
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Viewer count
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      _formatViewerCount(stream['viewerCount'] as int),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Info
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stream['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stream['hostName'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
