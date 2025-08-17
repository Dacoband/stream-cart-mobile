import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/review/review_entity.dart';
import '../../../domain/usecases/review/create_review_usecase.dart';
import '../../../domain/usecases/review/delete_review_usecase.dart';
import '../../../domain/usecases/review/get_review_by_id_usecase.dart';
import '../../../domain/usecases/review/get_reviews_by_livestream_usecase.dart';
import '../../../domain/usecases/review/get_reviews_by_order_usecase.dart';
import '../../../domain/usecases/review/get_reviews_by_product_usecase.dart';
import '../../../domain/usecases/review/get_reviews_by_user_usecase.dart';
import '../../../domain/usecases/review/update_review_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
	final CreateReviewUseCase createReview;
	final GetReviewByIdUseCase getReviewById;
	final UpdateReviewUseCase updateReview;
	final DeleteReviewUseCase deleteReview;
	final GetReviewsByOrderUseCase getReviewsByOrder;
	final GetReviewsByUserUseCase getReviewsByUser;
	final GetReviewsByLivestreamUseCase getReviewsByLivestream;
	final GetReviewsByProductUseCase getReviewsByProduct;

	List<ReviewEntity> _productReviews = const [];
	int _currentPage = 1;
	bool _hasReachedMax = false;
	String? _currentProductId;
		int? _minRating;
		int? _maxRating;
		bool? _verifiedOnly;
		String? _sortBy;
		bool _ascending = false;
		int _pageSize = 10;

	ReviewBloc({
		required this.createReview,
		required this.getReviewById,
		required this.updateReview,
		required this.deleteReview,
		required this.getReviewsByOrder,
		required this.getReviewsByUser,
		required this.getReviewsByLivestream,
		required this.getReviewsByProduct,
	}) : super(const ReviewInitial()) {
		on<LoadProductReviewsEvent>(_onLoadProductReviews);
		on<RefreshProductReviewsEvent>(_onRefreshProductReviews);
		on<LoadMoreProductReviewsEvent>(_onLoadMoreProductReviews);

		on<LoadReviewsByOrderEvent>(_onLoadByOrder);
		on<LoadReviewsByUserEvent>(_onLoadByUser);
		on<LoadReviewsByLivestreamEvent>(_onLoadByLivestream);

		on<CreateReviewEvent>(_onCreate);
		on<UpdateReviewEvent>(_onUpdate);
		on<DeleteReviewEvent>(_onDelete);
		on<GetReviewByIdEvent>(_onGetById);
		on<ResetReviewStateEvent>(_onReset);
	}

	void _resetPagination() {
		_productReviews = const [];
		_currentPage = 1;
		_hasReachedMax = false;
	}

	Future<void> _onLoadProductReviews(
		LoadProductReviewsEvent event,
		Emitter<ReviewState> emit,
	) async {
			final shouldReset = _currentProductId != event.productId ||
					_minRating != event.minRating ||
					_maxRating != event.maxRating ||
					_verifiedOnly != event.verifiedOnly ||
					_sortBy != event.sortBy ||
					_ascending != event.ascending;
		if (shouldReset) {
			_currentProductId = event.productId;
				_minRating = event.minRating;
				_maxRating = event.maxRating;
				_verifiedOnly = event.verifiedOnly;
				_sortBy = event.sortBy;
				_ascending = event.ascending;
				_pageSize = event.pageSize;
			_resetPagination();
		}

		emit(const ReviewLoading());

		final result = await getReviewsByProduct(
			GetReviewsByProductParams(
				productId: event.productId,
					pageNumber: 1,
					pageSize: event.pageSize,
					minRating: event.minRating,
					maxRating: event.maxRating,
					verifiedOnly: event.verifiedOnly,
					sortBy: event.sortBy,
					ascending: event.ascending,
			),
		);

		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) {
				_productReviews = reviews;
				_currentPage = 1;
			_hasReachedMax = reviews.length < _pageSize;
				emit(ProductReviewsLoaded(
					reviews: _productReviews,
					hasReachedMax: _hasReachedMax,
					currentPage: _currentPage,
				));
			},
		);
	}

	Future<void> _onRefreshProductReviews(
		RefreshProductReviewsEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(ReviewRefreshing(_productReviews));
		final result = await getReviewsByProduct(
			GetReviewsByProductParams(
				productId: event.productId,
		pageNumber: 1,
		pageSize: _pageSize,
		minRating: event.minRating,
		maxRating: event.maxRating,
		verifiedOnly: event.verifiedOnly,
		sortBy: event.sortBy,
		ascending: event.ascending,
			),
		);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) {
				_productReviews = reviews;
				_currentPage = 1;
		_hasReachedMax = reviews.length < _pageSize;
				emit(ProductReviewsLoaded(
					reviews: _productReviews,
					hasReachedMax: _hasReachedMax,
					currentPage: _currentPage,
				));
			},
		);
	}

	Future<void> _onLoadMoreProductReviews(
		LoadMoreProductReviewsEvent event,
		Emitter<ReviewState> emit,
	) async {
		if (_hasReachedMax || _currentProductId == null) return;

		emit(ReviewLoadingMore(_productReviews));

		final nextPage = _currentPage + 1;
		final result = await getReviewsByProduct(
			GetReviewsByProductParams(
			productId: _currentProductId!,
			pageNumber: nextPage,
			pageSize: event.pageSize,
			minRating: _minRating,
			maxRating: _maxRating,
			verifiedOnly: _verifiedOnly,
			sortBy: _sortBy,
			ascending: _ascending,
			),
		);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) {
				if (reviews.isEmpty) {
					_hasReachedMax = true;
				} else {
					_productReviews = List.of(_productReviews)..addAll(reviews);
					_currentPage = nextPage;
					_hasReachedMax = reviews.length < event.pageSize;
				}
				emit(ProductReviewsLoaded(
					reviews: _productReviews,
					hasReachedMax: _hasReachedMax,
					currentPage: _currentPage,
				));
			},
		);
	}

	Future<void> _onLoadByOrder(
		LoadReviewsByOrderEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await getReviewsByOrder(
			GetReviewsByOrderParams(orderId: event.orderId),
		);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) => emit(ReviewsByOrderLoaded(reviews)),
		);
	}

	Future<void> _onLoadByUser(
		LoadReviewsByUserEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await getReviewsByUser(
			GetReviewsByUserParams(userId: event.userId),
		);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) => emit(ReviewsByUserLoaded(reviews)),
		);
	}

	Future<void> _onLoadByLivestream(
		LoadReviewsByLivestreamEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await getReviewsByLivestream(
			GetReviewsByLivestreamParams(livestreamId: event.livestreamId),
		);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(reviews) => emit(ReviewsByLivestreamLoaded(reviews)),
		);
	}

	Future<void> _onCreate(
		CreateReviewEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await createReview(CreateReviewParams(request: event.request));
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(review) => emit(ReviewCreated(review)),
		);
	}

	Future<void> _onUpdate(
		UpdateReviewEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
			final result = await updateReview(
				UpdateReviewParams(
					reviewId: event.reviewId,
					rating: event.rating,
					reviewText: event.reviewText,
					imageUrls: event.imageUrls,
				),
			);
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(review) => emit(ReviewUpdated(review)),
		);
	}

	Future<void> _onDelete(
		DeleteReviewEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await deleteReview(DeleteReviewParams(reviewId: event.reviewId));
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(_) => emit(ReviewDeleted(event.reviewId)),
		);
	}

	Future<void> _onGetById(
		GetReviewByIdEvent event,
		Emitter<ReviewState> emit,
	) async {
		emit(const ReviewLoading());
		final result = await getReviewById(GetReviewByIdParams(reviewId: event.reviewId));
		result.fold(
			(failure) => emit(ReviewError(failure.message)),
			(review) => emit(ReviewByIdLoaded(review)),
		);
	}

		void _onReset(
			ResetReviewStateEvent event,
		Emitter<ReviewState> emit,
	) {
		_resetPagination();
		emit(const ReviewInitial());
	}
}

