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
import '../../../core/routing/app_router.dart';
import '../../widgets/common/confirm_dialog.dart';

class UserReviewsPage extends StatefulWidget {
  final String userId;
  const UserReviewsPage({super.key, required this.userId});

  @override
  State<UserReviewsPage> createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewsByUserEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đánh giá của tôi',
        style: TextStyle(color: AppColors.brandAccent, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      backgroundColor: AppColors.brandDark,
      foregroundColor: AppColors.brandAccent,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã xóa đánh giá')),
            );
            context.read<ReviewBloc>().add(LoadReviewsByUserEvent(widget.userId));
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const ReviewSkeletonList();
          }
          if (state is ReviewsByUserLoaded) {
            final items = state.reviews;
            if (items.isEmpty) return const ReviewEmpty();
            return ReviewListView(
              reviews: items,
              showFooterSpinner: false,
              showEndOfList: true,
              onEdit: (review) {
                Navigator.pushNamed(
                  context,
                  AppRouter.editReview,
                  arguments: {
                    'reviewId': review.id,
                    'initialReview': review,
                  },
                );
              },
              onDelete: (review) async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Xóa đánh giá',
                  message: 'Bạn có chắc muốn xóa đánh giá này?',
                  confirmText: 'Xóa',
                  cancelText: 'Hủy',
                  icon: Icons.delete_outline,
                  highlightColor: Theme.of(context).colorScheme.error,
                );
                if (confirmed == true) {
                  context.read<ReviewBloc>().add(DeleteReviewEvent(review.id));
                }
              },
            );
          }
          if (state is ReviewError) {
            return ReviewErrorView(message: state.message, onRetry: () {
              context.read<ReviewBloc>().add(LoadReviewsByUserEvent(widget.userId));
            });
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
