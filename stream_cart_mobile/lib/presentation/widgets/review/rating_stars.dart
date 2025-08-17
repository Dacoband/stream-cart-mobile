import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final int value; // 1..5
  final double size;
  const RatingStars({super.key, required this.value, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < value;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: filled ? AppColors.brandPrimary : Colors.grey.shade400,
          size: size,
        );
      }),
    );
  }
}
