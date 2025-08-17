import 'package:flutter/material.dart';

class ReviewEmpty extends StatelessWidget {
  const ReviewEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.reviews_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('Chưa có đánh giá nào'),
          ],
        ),
      ),
    );
  }
}
