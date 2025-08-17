import 'package:equatable/equatable.dart';
import '../../../domain/entities/review/review_entity.dart';

abstract class ReviewEvent extends Equatable {
	const ReviewEvent();

	@override
	List<Object?> get props => [];
}
class LoadProductReviewsEvent extends ReviewEvent {
	final String productId;
	final int pageNumber;
	final int pageSize;
	final int? minRating;
	final int? maxRating;
	final bool? verifiedOnly;
	final String? sortBy;
	final bool ascending;

	const LoadProductReviewsEvent({
		required this.productId,
		this.pageNumber = 1,
		this.pageSize = 10,
		this.minRating,
		this.maxRating,
		this.verifiedOnly,
		this.sortBy,
		this.ascending = false,
	});

	@override
	List<Object?> get props => [
				productId,
				pageNumber,
				pageSize,
				minRating,
				maxRating,
				verifiedOnly,
				sortBy,
				ascending,
			];
}

class LoadMoreProductReviewsEvent extends ReviewEvent {
	final String productId;
	final int currentPage;
	final int pageSize;
	final int? minRating;
	final int? maxRating;
	final bool? verifiedOnly;
	final String? sortBy;
	final bool ascending;

	const LoadMoreProductReviewsEvent({
		required this.productId,
		required this.currentPage,
		this.pageSize = 10,
		this.minRating,
		this.maxRating,
		this.verifiedOnly,
		this.sortBy,
		this.ascending = false,
	});

	@override
	List<Object?> get props => [
				productId,
				currentPage,
				pageSize,
				minRating,
				maxRating,
				verifiedOnly,
				sortBy,
				ascending,
			];
}

class RefreshProductReviewsEvent extends ReviewEvent {
	final String productId;
	final int? minRating;
	final int? maxRating;
	final bool? verifiedOnly;
	final String? sortBy;
	final bool ascending;

	const RefreshProductReviewsEvent({
		required this.productId,
		this.minRating,
		this.maxRating,
		this.verifiedOnly,
		this.sortBy,
		this.ascending = false,
	});

	@override
	List<Object?> get props => [productId, minRating, maxRating, verifiedOnly, sortBy, ascending];
}

class LoadReviewsByOrderEvent extends ReviewEvent {
	final String orderId;
	const LoadReviewsByOrderEvent(this.orderId);
	@override
	List<Object?> get props => [orderId];
}

class LoadReviewsByUserEvent extends ReviewEvent {
	final String userId;
	const LoadReviewsByUserEvent(this.userId);
	@override
	List<Object?> get props => [userId];
}

class LoadReviewsByLivestreamEvent extends ReviewEvent {
	final String livestreamId;
	const LoadReviewsByLivestreamEvent(this.livestreamId);
	@override
	List<Object?> get props => [livestreamId];
}

// CRUD
class CreateReviewEvent extends ReviewEvent {
	final ReviewRequestEntity request;
	const CreateReviewEvent(this.request);
	@override
	List<Object?> get props => [request];
}

class UpdateReviewEvent extends ReviewEvent {
	final String reviewId;
	final int? rating;
	final String? reviewText;
	final List<String>? imageUrls;

	const UpdateReviewEvent({
		required this.reviewId,
		this.rating,
		this.reviewText,
		this.imageUrls,
	});

	@override
	List<Object?> get props => [reviewId, rating, reviewText, imageUrls];
}

class DeleteReviewEvent extends ReviewEvent {
	final String reviewId;
	const DeleteReviewEvent(this.reviewId);
	@override
	List<Object?> get props => [reviewId];
}

class GetReviewByIdEvent extends ReviewEvent {
	final String reviewId;
	const GetReviewByIdEvent(this.reviewId);
	@override
	List<Object?> get props => [reviewId];
}

class ResetReviewStateEvent extends ReviewEvent {
	const ResetReviewStateEvent();
}

