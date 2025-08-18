import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/review/review_list_item.dart';

class ReviewDetailPage extends StatefulWidget {
  final String reviewId;
  const ReviewDetailPage({super.key, required this.reviewId});

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(GetReviewByIdEvent(widget.reviewId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đánh giá',
        style: TextStyle(color: AppColors.brandAccent, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      backgroundColor: AppColors.brandDark,
      foregroundColor: AppColors.brandAccent,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReviewByIdLoaded) {
            return ListView(children: [ReviewListItem(review: state.review)]);
          }
          if (state is ReviewError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
