import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MerchantReply extends StatelessWidget {
  final String shopName;
  final String replyText;
  const MerchantReply({super.key, required this.shopName, required this.replyText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bubbleNeutral,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Phản hồi từ $shopName', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        Text(replyText, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}
