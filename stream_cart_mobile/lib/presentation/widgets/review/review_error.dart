import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ReviewErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ReviewErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, foregroundColor: Colors.white),
            child: const Text('Thử lại'),
          )
        ]),
      ),
    );
  }
}
