import 'package:flutter/material.dart';
import '../../../domain/entities/review/review_entity.dart';
import 'review_list_item.dart';

class ReviewListView extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final bool showFooterSpinner;
  final bool showEndOfList;
  final void Function(ReviewEntity review)? onEdit;
  final void Function(ReviewEntity review)? onDelete;

  const ReviewListView({
    super.key,
    required this.reviews,
    this.showFooterSpinner = false,
    this.showEndOfList = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: reviews.length + 1,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == reviews.length) {
          if (showFooterSpinner) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (showEndOfList) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('Đã hiển thị tất cả')),
            );
          }
          return const SizedBox.shrink();
        }
        final item = reviews[index];
        return ReviewListItem(
          review: item,
          onEdit: onEdit != null ? () => onEdit!(item) : null,
          onDelete: onDelete != null ? () => onDelete!(item) : null,
        );
      },
    );
  }
}
