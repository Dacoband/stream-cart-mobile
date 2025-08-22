import 'package:flutter/material.dart';

class EmptyLiveCartWidget extends StatelessWidget {
  final VoidCallback? onBackToLive;
  const EmptyLiveCartWidget({super.key, this.onBackToLive});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có sản phẩm nào trong giỏ live',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Chọn sản phẩm trong livestream để thêm vào giỏ hàng',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onBackToLive,
              icon: const Icon(Icons.live_tv, size: 18),
              label: const Text('Quay lại livestream'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF89C036),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
