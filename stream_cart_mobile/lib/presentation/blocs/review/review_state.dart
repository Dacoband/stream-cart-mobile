import 'package:equatable/equatable.dart';
import '../../../domain/entities/review/review_entity.dart';

abstract class ReviewState extends Equatable {
	const ReviewState();
	@override
	List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
	const ReviewInitial();
}

class ReviewLoading extends ReviewState {
	const ReviewLoading();
}

class ReviewRefreshing extends ReviewState {
	final List<ReviewEntity> current;
	const ReviewRefreshing(this.current);
	@override
	List<Object?> get props => [current];
}

class ReviewLoadingMore extends ReviewState {
	final List<ReviewEntity> current;
	const ReviewLoadingMore(this.current);
	@override
	List<Object?> get props => [current];
}

class ProductReviewsLoaded extends ReviewState {
	final List<ReviewEntity> reviews;
	final bool hasReachedMax;
	final int currentPage;
	const ProductReviewsLoaded({
		required this.reviews,
		required this.hasReachedMax,
		required this.currentPage,
	});
	@override
	List<Object?> get props => [reviews, hasReachedMax, currentPage];
}

class ReviewsByOrderLoaded extends ReviewState {
	final List<ReviewEntity> reviews;
	const ReviewsByOrderLoaded(this.reviews);
	@override
	List<Object?> get props => [reviews];
}

class ReviewsByUserLoaded extends ReviewState {
	final List<ReviewEntity> reviews;
	const ReviewsByUserLoaded(this.reviews);
	@override
	List<Object?> get props => [reviews];
}

class ReviewsByLivestreamLoaded extends ReviewState {
	final List<ReviewEntity> reviews;
	const ReviewsByLivestreamLoaded(this.reviews);
	@override
	List<Object?> get props => [reviews];
}

class ReviewByIdLoaded extends ReviewState {
	final ReviewEntity review;
	const ReviewByIdLoaded(this.review);
	@override
	List<Object?> get props => [review];
}

class ReviewCreated extends ReviewState {
	final ReviewEntity review;
	const ReviewCreated(this.review);
	@override
	List<Object?> get props => [review];
}

class ReviewUpdated extends ReviewState {
	final ReviewEntity review;
	const ReviewUpdated(this.review);
	@override
	List<Object?> get props => [review];
}

class ReviewDeleted extends ReviewState {
	final String reviewId;
	const ReviewDeleted(this.reviewId);
	@override
	List<Object?> get props => [reviewId];
}

class ReviewOperationSuccess extends ReviewState {
	final String message;
	const ReviewOperationSuccess(this.message);
	@override
	List<Object?> get props => [message];
}

class ReviewError extends ReviewState {
	final String message;
	const ReviewError(this.message);
	@override
	List<Object?> get props => [message];
}

