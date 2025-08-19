import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/review/review_entity.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewRequestModel {
	@JsonKey(name: 'orderID')
	final String? orderID;

	@JsonKey(name: 'productID')
	final String? productID;

	@JsonKey(name: 'livestreamId')
	final String? livestreamId;

	@JsonKey(name: 'rating')
	final int? rating;

	@JsonKey(name: 'reviewText')
	final String? reviewText;

	@JsonKey(name: 'imageUrls')
	final List<String>? imageUrls;

	const ReviewRequestModel({
		this.orderID,
		this.productID,
		this.livestreamId,
		this.rating,
		this.reviewText,
		this.imageUrls,
	});

	factory ReviewRequestModel.fromJson(Map<String, dynamic> json) => _$ReviewRequestModelFromJson(json);
	Map<String, dynamic> toJson() => _$ReviewRequestModelToJson(this);

	ReviewRequestEntity toEntity() => ReviewRequestEntity(
				orderID: orderID,
				productID: productID,
				livestreamId: livestreamId,
				rating: rating,
				reviewText: reviewText,
				imageUrls: imageUrls,
			);

	factory ReviewRequestModel.fromEntity(ReviewRequestEntity entity) => ReviewRequestModel(
				orderID: entity.orderID,
				productID: entity.productID,
				livestreamId: entity.livestreamId,
				rating: entity.rating,
				reviewText: entity.reviewText,
				imageUrls: entity.imageUrls,
			);
}

@JsonSerializable()
class ReviewModel {
	@JsonKey(name: 'id')
	final String id;

	@JsonKey(name: 'orderID')
	final String? orderID;

	@JsonKey(name: 'productID')
	final String? productID;

	@JsonKey(name: 'livestreamId')
	final String? livestreamId;

	@JsonKey(name: 'accountID')
	final String accountID;

	@JsonKey(name: 'rating')
	final int rating;

	@JsonKey(name: 'reviewText')
	final String? reviewText;

	@JsonKey(name: 'isVerifiedPurchase')
	final bool isVerifiedPurchase;

	@JsonKey(name: 'type')
	final int type;

	@JsonKey(name: 'typeDisplayName')
	final String typeDisplayName;

	@JsonKey(name: 'imageUrls', defaultValue: [])
	final List<String> imageUrls;

	@JsonKey(name: 'createdAt')
	final String createdAt;

	@JsonKey(name: 'approvedAt')
	final String? approvedAt;

	@JsonKey(name: 'approvedBy')
	final String? approvedBy;

	@JsonKey(name: 'helpfulCount')
	final int helpfulCount;

	@JsonKey(name: 'unhelpfulCount')
	final int unhelpfulCount;

	@JsonKey(name: 'productName')
	final String? productName;

	@JsonKey(name: 'productImageUrl')
	final String? productImageUrl;

	@JsonKey(name: 'orderCode')
	final String? orderCode;

	@JsonKey(name: 'livestreamTitle')
	final String? livestreamTitle;

	@JsonKey(name: 'reviewerName')
	final String? reviewerName;

	@JsonKey(name: 'shopName')
	final String? shopName;

	@JsonKey(name: 'avatarImage')
	final String? avatarImage;

	@JsonKey(name: 'userName')
	final String? userName;

	const ReviewModel({
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

	factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
	Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

	ReviewEntity toEntity() => ReviewEntity(
				id: id,
				orderID: orderID,
				productID: productID,
				livestreamId: livestreamId,
				accountID: accountID,
				rating: rating,
				reviewText: reviewText,
				isVerifiedPurchase: isVerifiedPurchase,
				type: type,
				typeDisplayName: typeDisplayName,
				imageUrls: imageUrls,
				createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
				approvedAt: approvedAt != null ? DateTime.tryParse(approvedAt!) : null,
				approvedBy: approvedBy,
				helpfulCount: helpfulCount,
				unhelpfulCount: unhelpfulCount,
				productName: productName,
				productImageUrl: productImageUrl,
				orderCode: orderCode,
				livestreamTitle: livestreamTitle,
				reviewerName: reviewerName,
			shopName: shopName,
			avatarImage: avatarImage,
			userName: userName,
			);
}

@JsonSerializable()
class ReviewResponseModel {
	@JsonKey(name: 'success')
	final bool success;

	@JsonKey(name: 'message')
	final String message;

	@JsonKey(name: 'data')
	final ReviewModel? data;

	@JsonKey(name: 'errors', defaultValue: [])
	final List<String> errors;

	const ReviewResponseModel({
		required this.success,
		required this.message,
		this.data,
		required this.errors,
	});

	factory ReviewResponseModel.fromJson(Map<String, dynamic> json) => _$ReviewResponseModelFromJson(json);
	Map<String, dynamic> toJson() => _$ReviewResponseModelToJson(this);

	ReviewResponseEntity toEntity() => ReviewResponseEntity(
				success: success,
				message: message,
				data: data?.toEntity(),
				errors: errors,
			);
}

