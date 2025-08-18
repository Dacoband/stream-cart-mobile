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
    );
  }
}
