import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../widgets/review/review_list_view.dart';
import '../../widgets/review/review_filters_bar.dart';
import '../../widgets/review/review_summary_section.dart';
import '../../widgets/review/review_skeleton_list.dart';
import '../../widgets/review/review_empty.dart';
import '../../widgets/review/review_error.dart';
import '../../widgets/review/infinite_scroll_listener.dart';
import '../../theme/app_colors.dart';

class ProductReviewsPage extends StatefulWidget {
  final String productId;
  const ProductReviewsPage({super.key, required this.productId});

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  int? _minRating;
  int? _maxRating;
  bool? _verifiedOnly;
  String? _sortBy;
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadProductReviewsEvent(productId: widget.productId));
  }

  void _onRefresh() {
    context.read<ReviewBloc>().add(RefreshProductReviewsEvent(
          productId: widget.productId,
          minRating: _minRating,
          maxRating: _maxRating,
          verifiedOnly: _verifiedOnly,
          sortBy: _sortBy,
          ascending: _ascending,
        ));
  }

  void _onLoadMore() {
    final state = context.read<ReviewBloc>().state;
    if (state is ProductReviewsLoaded) {
      context.read<ReviewBloc>().add(LoadMoreProductReviewsEvent(
            productId: widget.productId,
            currentPage: state.currentPage,
            pageSize: 10,
            minRating: _minRating,
            maxRating: _maxRating,
            verifiedOnly: _verifiedOnly,
            sortBy: _sortBy,
            ascending: _ascending,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const 
        Text('Đánh giá sản phẩm',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        backgroundColor: Color(0xFF202328),
        foregroundColor: Color(0xFFB0F847),
      ),
      body: Column(
        children: [
          ReviewSummarySection(productId: widget.productId),
          ReviewFiltersBar(
            initialVerifiedOnly: _verifiedOnly ?? false,
            onChanged: (minRating, maxRating, verified, sortBy, asc) {
              setState(() {
                _minRating = minRating;
                _maxRating = maxRating;
                _verifiedOnly = verified ? true : null;
                _sortBy = sortBy;
                _ascending = asc;
              });
              context.read<ReviewBloc>().add(LoadProductReviewsEvent(
                    productId: widget.productId,
                    pageNumber: 1,
                    pageSize: 10,
                    minRating: _minRating,
                    maxRating: _maxRating,
                    verifiedOnly: _verifiedOnly,
                    sortBy: _sortBy,
                    ascending: _ascending,
                  ));
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocConsumer<ReviewBloc, ReviewState>(
              listener: (context, state) {
                if (state is ReviewError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: AppColors.brandDark),
                  );
                }
              },
              builder: (context, state) {
                if (state is ReviewLoading) return const ReviewSkeletonList();

                if (state is ProductReviewsLoaded ||
                    state is ReviewRefreshing ||
                    state is ReviewLoadingMore) {
                  final list = state is ProductReviewsLoaded
                      ? state.reviews
                      : state is ReviewRefreshing
                          ? state.current
                          : (state as ReviewLoadingMore).current;
                  final hasReachedMax = state is ProductReviewsLoaded ? state.hasReachedMax : false;

                  return InfiniteScrollListener(
                    onEndReached: _onLoadMore,
                    child: RefreshIndicator(
                      onRefresh: () async => _onRefresh(),
                      color: AppColors.brandPrimary,
                      child: list.isEmpty
                          ? const ReviewEmpty()
                          : ReviewListView(
                              reviews: list,
                              showFooterSpinner: state is ReviewLoadingMore,
                              showEndOfList: hasReachedMax,
                            ),
                    ),
                  );
                }

                if (state is ReviewError) return ReviewErrorView(message: state.message, onRetry: _onRefresh);

                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
