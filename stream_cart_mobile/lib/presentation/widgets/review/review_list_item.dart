import 'package:flutter/material.dart';
import '../../../domain/entities/review/review_entity.dart';
import '../../theme/app_colors.dart';
import 'rating_stars.dart';
import 'merchant_reply.dart';

class ReviewListItem extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewListItem({super.key, required this.review, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: AppColors.brandPrimary, child: Text(review.reviewerName?.substring(0, 1) ?? '?')),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(review.reviewerName ?? 'Người dùng', style: Theme.of(context).textTheme.titleSmall),
                  Text(_formatDate(review.createdAt), style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit' && onEdit != null) onEdit!();
                    if (v == 'delete' && onDelete != null) onDelete!();
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null) const PopupMenuItem(value: 'edit', child: Text('Sửa')),
                    if (onDelete != null) const PopupMenuItem(value: 'delete', child: Text('Xóa')),
                  ],
                )
            ],
          ),
          const SizedBox(height: 6),
          Row(children: [
            RatingStars(value: review.rating),
            const SizedBox(width: 8),
            if (review.isVerifiedPurchase)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.bubbleNeutral, borderRadius: BorderRadius.circular(999)),
                child: const Text('Đã mua', style: TextStyle(fontSize: 12)),
              ),
          ]),
          if ((review.reviewText ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.reviewText!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            _ImagesGrid(urls: review.imageUrls),
          ],
          if ((review.shopName?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 10),
            MerchantReply(shopName: review.shopName!, replyText: 'Cảm ơn bạn đã đánh giá!'),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}

class _ImagesGrid extends StatelessWidget {
  final List<String> urls;
  const _ImagesGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    final show = urls.take(4).toList();
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: show.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4),
      itemBuilder: (_, i) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(show[i], fit: BoxFit.cover),
        );
      },
    );
  }
}
