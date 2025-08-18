import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_state.dart';

class ProductReviewsPreview extends StatelessWidget {
  final String productId;
  const ProductReviewsPreview({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đánh giá sản phẩm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF202328)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.productReviews, arguments: productId);
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading) {
                return const Center(child: SizedBox(height: 80, child: CircularProgressIndicator()));
              }
              if (state is ProductReviewsLoaded) {
                final items = state.reviews;
                if (items.isEmpty) {
                  return const Text('Chưa có đánh giá');
                }
                return Column(
                  children: [
        ...items.take(3).map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MiniReviewTile(
                          name: e.reviewerName ?? 'Người dùng',
                          rating: e.rating,
                          text: e.reviewText ?? '',
          createdAt: e.createdAt,
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is ReviewError) {
                return Text(state.message, style: const TextStyle(color: Colors.red));
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.writeReview, arguments: productId);
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Viết đánh giá'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String text;
  final DateTime createdAt;
  const _MiniReviewTile({required this.name, required this.rating, required this.text, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Row(
                    children: List.generate(5, (i) {
                      final filled = i < rating;
                      return Icon(
                        filled ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 14,
                        color: filled ? const Color(0xFF4CAF50) : Colors.grey,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimeAgo(createdAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF202328)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.isNegative || diff.inDays >= 7) {
      final d = dateTime.day.toString().padLeft(2, '0');
      final m = dateTime.month.toString().padLeft(2, '0');
      return '$d/$m/${dateTime.year}';
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
}
