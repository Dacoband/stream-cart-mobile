// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewRequestModel _$ReviewRequestModelFromJson(Map<String, dynamic> json) =>
    ReviewRequestModel(
      orderID: json['orderID'] as String?,
      productID: json['productID'] as String?,
      livestreamId: json['livestreamId'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      reviewText: json['reviewText'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReviewRequestModelToJson(ReviewRequestModel instance) =>
    <String, dynamic>{
      'orderID': instance.orderID,
      'productID': instance.productID,
      'livestreamId': instance.livestreamId,
      'rating': instance.rating,
      'reviewText': instance.reviewText,
      'imageUrls': instance.imageUrls,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['id'] as String,
      orderID: json['orderID'] as String?,
      productID: json['productID'] as String?,
      livestreamId: json['livestreamId'] as String?,
      accountID: json['accountID'] as String,
      rating: (json['rating'] as num).toInt(),
      reviewText: json['reviewText'] as String?,
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool,
      type: (json['type'] as num).toInt(),
      typeDisplayName: json['typeDisplayName'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      approvedAt: json['approvedAt'] as String?,
      approvedBy: json['approvedBy'] as String?,
      helpfulCount: (json['helpfulCount'] as num).toInt(),
      unhelpfulCount: (json['unhelpfulCount'] as num).toInt(),
      productName: json['productName'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      orderCode: json['orderCode'] as String?,
      livestreamTitle: json['livestreamTitle'] as String?,
      reviewerName: json['reviewerName'] as String?,
      shopName: json['shopName'] as String?,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderID': instance.orderID,
      'productID': instance.productID,
      'livestreamId': instance.livestreamId,
      'accountID': instance.accountID,
      'rating': instance.rating,
      'reviewText': instance.reviewText,
      'isVerifiedPurchase': instance.isVerifiedPurchase,
      'type': instance.type,
      'typeDisplayName': instance.typeDisplayName,
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt,
      'approvedAt': instance.approvedAt,
      'approvedBy': instance.approvedBy,
      'helpfulCount': instance.helpfulCount,
      'unhelpfulCount': instance.unhelpfulCount,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'orderCode': instance.orderCode,
      'livestreamTitle': instance.livestreamTitle,
      'reviewerName': instance.reviewerName,
      'shopName': instance.shopName,
    };

ReviewResponseModel _$ReviewResponseModelFromJson(Map<String, dynamic> json) =>
    ReviewResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ReviewModel.fromJson(json['data'] as Map<String, dynamic>),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ReviewResponseModelToJson(
        ReviewResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };
