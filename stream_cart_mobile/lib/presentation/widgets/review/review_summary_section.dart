import 'package:flutter/material.dart';
import 'rating_stars.dart';

class ReviewSummarySection extends StatelessWidget {
  final String productId;
  const ReviewSummarySection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Placeholder summary; wire to real data later
    const avg = 4;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          RatingStars(value: avg, size: 20),
          SizedBox(width: 8),
          Text('4.0 · 128 đánh giá'),
        ],
      ),
    );
  }
}
