import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/review/review_compose_form.dart';
import '../../../domain/entities/review/review_entity.dart';

class WriteReviewPage extends StatefulWidget {
  final String productId; // You can extend: orderId/livestreamId
  const WriteReviewPage({super.key, required this.productId});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  bool _submitting = false;

  Future<void> _handleSubmit({required int rating, required String text, required List<String> images}) async {
    setState(() => _submitting = true);
    final request = ReviewRequestEntity(productID: widget.productId, rating: rating, reviewText: text, imageUrls: images);
    context.read<ReviewBloc>().add(CreateReviewEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Viết đánh giá',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        backgroundColor: Color(0xFF202328),
        foregroundColor: Color(0xFFB0F847),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.brandDark));
          } else if (state is ReviewCreated) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi đánh giá')));
            Navigator.of(context).pop(true);
          } else if (state is ReviewLoading) {
            // keep submitting state
          }
        },
        builder: (context, state) {
          return ReviewComposeForm(onSubmit: _handleSubmit, isSubmitting: _submitting);
        },
      ),
    );
  }
}
