import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/review/review_list_view.dart';
import '../../widgets/review/review_error.dart';
import '../../widgets/review/review_empty.dart';
import '../../widgets/review/review_skeleton_list.dart';

class OrderReviewsPage extends StatefulWidget {
  final String orderId;
  const OrderReviewsPage({super.key, required this.orderId});

  @override
  State<OrderReviewsPage> createState() => _OrderReviewsPageState();
}

class _OrderReviewsPageState extends State<OrderReviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewsByOrderEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đánh giá đơn hàng',
        style: TextStyle(color: AppColors.brandAccent, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      backgroundColor: AppColors.brandDark,
      foregroundColor: AppColors.brandAccent,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const ReviewSkeletonList();
          }
          if (state is ReviewsByOrderLoaded) {
            final items = state.reviews;
            if (items.isEmpty) return const ReviewEmpty();
            return ReviewListView(
              reviews: items,
              showFooterSpinner: false,
              showEndOfList: true,
            );
          }
          if (state is ReviewError) {
            return ReviewErrorView(message: state.message, onRetry: () {
              context.read<ReviewBloc>().add(LoadReviewsByOrderEvent(widget.orderId));
            });
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateReviewOptions(context),
        backgroundColor: AppColors.brandAccent,
        foregroundColor: AppColors.brandDark,
        icon: const Icon(Icons.add),
        label: const Text('Viết đánh giá'),
      ),
    );
  }

  void _showCreateReviewOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chọn sản phẩm để đánh giá',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.rate_review,
                  color: AppColors.brandAccent,
                ),
              ),
              title: const Text('Đánh giá toàn bộ đơn hàng'),
              subtitle: const Text('Đánh giá chung về đơn hàng này'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/write-review',
                  arguments: {
                    'orderId': widget.orderId,
                  },
                );
              },
            ),
            const Divider(),
            const Text(
              'Hoặc đánh giá sản phẩm cụ thể:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              title: const Text('Đánh giá sản phẩm'),
              subtitle: const Text('Chọn sản phẩm để đánh giá riêng'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show product selection for this specific order
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng này sẽ được phát triển sau'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
