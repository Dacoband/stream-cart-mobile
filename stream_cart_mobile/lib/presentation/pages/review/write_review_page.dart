import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/review/review_compose_form.dart';
import '../../../domain/entities/review/review_entity.dart';

/// Trang viết đánh giá tổng quát (product | order | livestream)
class WriteReviewPage extends StatefulWidget {
  final String? productId;
  final String? orderId;
  final String? livestreamId;

  const WriteReviewPage({super.key, this.productId, this.orderId, this.livestreamId})
      : assert(
          productId != null || orderId != null || livestreamId != null,
          'At least one of productId, orderId, livestreamId must be provided',
        );

  bool get isProduct => productId != null && orderId == null && livestreamId == null;
  bool get isOrder => orderId != null && productId == null && livestreamId == null;
  bool get isLivestream => livestreamId != null && productId == null && orderId == null;
  bool get isProductFromOrder => productId != null && orderId != null && livestreamId == null;

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  bool _submitting = false;

  String get _title {
    if (widget.isOrder) return 'Đánh giá đơn hàng';
    if (widget.isLivestream) return 'Đánh giá livestream';
    if (widget.isProductFromOrder) return 'Đánh giá sản phẩm';
    return 'Viết đánh giá'; // product only
  }

  Future<void> _handleSubmit({required int rating, required String text, required List<String> images}) async {
    setState(() => _submitting = true);
    final request = ReviewRequestEntity(
      productID: widget.productId,
      orderID: widget.orderId,
      livestreamId: widget.livestreamId,
      rating: rating,
      reviewText: text,
      imageUrls: images,
    );
    context.read<ReviewBloc>().add(CreateReviewEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF202328),
        foregroundColor: const Color(0xFFB0F847),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.brandDark),
            );
          } else if (state is ReviewCreated) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi đánh giá')));
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) => ReviewComposeForm(onSubmit: _handleSubmit, isSubmitting: _submitting),
      ),
    );
  }
}
