import 'package:equatable/equatable.dart';

class ReviewRequestEntity extends Equatable {
	final String? orderID;
	final String? productID;
	final String? livestreamId;
	final int? rating;
	final String? reviewText;
	final List<String>? imageUrls;

	const ReviewRequestEntity({
		this.orderID,
		this.productID,
		this.livestreamId,
		this.rating,
		this.reviewText,
		this.imageUrls,
	});

	ReviewRequestEntity copyWith({
		String? orderID,
		String? productID,
		String? livestreamId,
		int? rating,
		String? reviewText,
		List<String>? imageUrls,
	}) {
		return ReviewRequestEntity(
			orderID: orderID ?? this.orderID,
			productID: productID ?? this.productID,
			livestreamId: livestreamId ?? this.livestreamId,
			rating: rating ?? this.rating,
			reviewText: reviewText ?? this.reviewText,
			imageUrls: imageUrls ?? this.imageUrls,
		);
	}

	Map<String, dynamic> toJson() => {
				'orderID': orderID,
				'productID': productID,
				'livestreamId': livestreamId,
				'rating': rating,
				'reviewText': reviewText,
				'imageUrls': imageUrls,
			};

	@override
	List<Object?> get props => [orderID, productID, livestreamId, rating, reviewText, imageUrls];
}

class ReviewEntity extends Equatable {
	final String id;
	final String? orderID;
	final String? productID;
	final String? livestreamId;
	final String accountID;
	final int rating;
	final String? reviewText;
	final bool isVerifiedPurchase;
	final int type;
	final String typeDisplayName;
	final List<String> imageUrls;
	final DateTime createdAt;
	final DateTime? approvedAt;
	final String? approvedBy;
	final int helpfulCount;
	final int unhelpfulCount;
	final String? productName;
	final String? productImageUrl;
	final String? orderCode;
	final String? livestreamTitle;
	final String? reviewerName;
	final String? shopName;
	final String? avatarImage;
	final String? userName;

	const ReviewEntity({
		required this.id,
		this.orderID,
		this.productID,
		this.livestreamId,
		required this.accountID,
		required this.rating,
		this.reviewText,
		required this.isVerifiedPurchase,
		required this.type,
		required this.typeDisplayName,
		required this.imageUrls,
		required this.createdAt,
		this.approvedAt,
		this.approvedBy,
		required this.helpfulCount,
		required this.unhelpfulCount,
		this.productName,
		this.productImageUrl,
		this.orderCode,
		this.livestreamTitle,
		this.reviewerName,
		this.shopName,
		this.avatarImage,
		this.userName,
	});

	ReviewEntity copyWith({
		String? id,
		String? orderID,
		String? productID,
		String? livestreamId,
		String? accountID,
		int? rating,
		String? reviewText,
		bool? isVerifiedPurchase,
		int? type,
		String? typeDisplayName,
		List<String>? imageUrls,
		DateTime? createdAt,
		DateTime? approvedAt,
		String? approvedBy,
		int? helpfulCount,
		int? unhelpfulCount,
		String? productName,
		String? productImageUrl,
		String? orderCode,
		String? livestreamTitle,
		String? reviewerName,
		String? shopName,
		String? avatarImage,
		String? userName,
	}) {
		return ReviewEntity(
			id: id ?? this.id,
			orderID: orderID ?? this.orderID,
			productID: productID ?? this.productID,
			livestreamId: livestreamId ?? this.livestreamId,
			accountID: accountID ?? this.accountID,
			rating: rating ?? this.rating,
			reviewText: reviewText ?? this.reviewText,
			isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
			type: type ?? this.type,
			typeDisplayName: typeDisplayName ?? this.typeDisplayName,
			imageUrls: imageUrls ?? this.imageUrls,
			createdAt: createdAt ?? this.createdAt,
			approvedAt: approvedAt ?? this.approvedAt,
			approvedBy: approvedBy ?? this.approvedBy,
			helpfulCount: helpfulCount ?? this.helpfulCount,
			unhelpfulCount: unhelpfulCount ?? this.unhelpfulCount,
			productName: productName ?? this.productName,
			productImageUrl: productImageUrl ?? this.productImageUrl,
			orderCode: orderCode ?? this.orderCode,
			livestreamTitle: livestreamTitle ?? this.livestreamTitle,
			reviewerName: reviewerName ?? this.reviewerName,
			shopName: shopName ?? this.shopName,
			avatarImage: avatarImage ?? this.avatarImage,
			userName: userName ?? this.userName,
		);
	}

	@override
	List<Object?> get props => [
				id,
				orderID,
				productID,
				livestreamId,
				accountID,
				rating,
				reviewText,
				isVerifiedPurchase,
				type,
				typeDisplayName,
				imageUrls,
				createdAt,
				approvedAt,
				approvedBy,
				helpfulCount,
				unhelpfulCount,
				productName,
				productImageUrl,
				orderCode,
				livestreamTitle,
				reviewerName,
				shopName,
				avatarImage,
				userName,
			];
}

class ReviewResponseEntity extends Equatable {
	final bool success;
	final String message;
	final ReviewEntity? data;
	final List<String> errors;

	const ReviewResponseEntity({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	@override
	List<Object?> get props => [success, message, data, errors];
}

