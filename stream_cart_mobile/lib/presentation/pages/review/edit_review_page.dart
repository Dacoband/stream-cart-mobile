import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/review/review_compose_form.dart';
import '../../../domain/entities/review/review_entity.dart';

class EditReviewPage extends StatefulWidget {
  final String reviewId;
  final ReviewEntity? initialReview;
  const EditReviewPage({super.key, required this.reviewId, this.initialReview});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  bool _loading = false;
  bool _submitting = false;
  ReviewEntity? _review;

  @override
  void initState() {
    super.initState();
    _review = widget.initialReview;
    if (_review == null) {
      _loading = true;
      context.read<ReviewBloc>().add(GetReviewByIdEvent(widget.reviewId));
    }
  }

  Future<void> _handleSubmit({required int rating, required String text, required List<String> images}) async {
    setState(() => _submitting = true);
    context.read<ReviewBloc>().add(UpdateReviewEvent(reviewId: widget.reviewId, rating: rating, reviewText: text, imageUrls: images));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa đánh giá',
        style: TextStyle(color: AppColors.brandAccent, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      backgroundColor: AppColors.brandDark,
      foregroundColor: AppColors.brandAccent,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.brandDark));
          } else if (state is ReviewUpdated) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật đánh giá')));
            Navigator.of(context).pop(true);
          } else if (state is ReviewByIdLoaded) {
            setState(() {
              _loading = false;
              _review = state.review;
            });
          }
        },
        builder: (context, state) {
          if (_loading && _review == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ReviewComposeForm(
            initialRating: _review?.rating,
            initialText: _review?.reviewText,
            initialImages: _review?.imageUrls,
            onSubmit: _handleSubmit,
            isSubmitting: _submitting,
          );
        },
      ),
    );
  }
}
