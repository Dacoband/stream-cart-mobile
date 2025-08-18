import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../domain/entities/review/review_entity.dart';
import '../../theme/app_colors.dart';
import 'rating_stars.dart';
import 'merchant_reply.dart';
import '../../../core/routing/app_router.dart';

class ReviewListItem extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewListItem({super.key, required this.review, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasActions = onEdit != null || onDelete != null;
    final List<Widget> actions = [
      if (onEdit != null)
        CustomSlidableAction(
          onPressed: (_) => onEdit!.call(),
          backgroundColor: AppColors.brandPrimary.withValues(alpha: 0.08),
          foregroundColor: AppColors.brandPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.edit_outlined, size: 20, color: AppColors.brandPrimary),
              SizedBox(height: 6),
              SizedBox(width: 60, child: Text('Sửa', textAlign: TextAlign.center, maxLines: 1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.brandDark))),
            ],
          ),
        ),
      if (onDelete != null)
        CustomSlidableAction(
          onPressed: (_) => onDelete!.call(),
          backgroundColor: const Color(0xFFFFEBEE),
          foregroundColor: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete_outline, size: 20, color: Colors.red),
              SizedBox(height: 6),
              SizedBox(width: 60, child: Text('Xóa', textAlign: TextAlign.center, maxLines: 1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red))),
            ],
          ),
        ),
    ];

    final content = InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRouter.reviewDetail,
        arguments: review.id,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
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
                  Text(_formatTimeAgo(review.createdAt), style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
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
    ));

    if (!hasActions) return content;

    final extentRatio = actions.length == 2 ? 0.46 : 0.24;
    return Slidable(
      key: ValueKey('review-${review.id}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: extentRatio,
        children: actions,
      ),
      child: content,
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    Duration diff = now.difference(dateTime);
    // If future date or more than a week old, show full date
    if (diff.isNegative || diff.inDays >= 7) {
      return _formatDate(dateTime);
    }
    if (diff.inSeconds < 60) {
      final s = diff.inSeconds;
      return s <= 1 ? 'Vừa xong' : '$s giây trước';
    }
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return m == 1 ? '1 phút trước' : '$m phút trước';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return h == 1 ? '1 giờ trước' : '$h giờ trước';
    }
    final d = diff.inDays;
    return d == 1 ? '1 ngày trước' : '$d ngày trước';
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
