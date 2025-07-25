import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final String notificationId;
  final String? recipentUserId;
  final String? orderCode;
  final String? productId;
  final String? variantId;
  final String? livestreamId;
  final String type;
  final String message;
  final String? linkUrl;
  final bool isRead;
  final String created;

  const NotificationModel({
    required this.notificationId,
    this.recipentUserId,
    this.orderCode,
    this.productId,
    this.variantId,
    this.livestreamId,
    required this.type,
    required this.message,
    this.linkUrl,
    required this.isRead,
    required this.created,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      recipentUserId: json['recipentUserId'],
      orderCode: json['orderCode'],
      productId: json['productId'],
      variantId: json['variantId'],
      livestreamId: json['livestreamId'],
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      linkUrl: json['linkUrl'],
      isRead: json['isRead'] ?? false,
      created: json['created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'recipentUserId': recipentUserId,
      'orderCode': orderCode,
      'productId': productId,
      'variantId': variantId,
      'livestreamId': livestreamId,
      'type': type,
      'message': message,
      'linkUrl': linkUrl,
      'isRead': isRead,
      'created': created,
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      notificationId: notificationId,
      recipentUserId: recipentUserId,
      orderCode: orderCode,
      productId: productId,
      variantId: variantId,
      livestreamId: livestreamId,
      type: type,
      message: message,
      linkUrl: linkUrl,
      isRead: isRead,
      created: DateTime.tryParse(created) ?? DateTime.now(),
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      notificationId: entity.notificationId,
      recipentUserId: entity.recipentUserId,
      orderCode: entity.orderCode,
      productId: entity.productId,
      variantId: entity.variantId,
      livestreamId: entity.livestreamId,
      type: entity.type,
      message: entity.message,
      linkUrl: entity.linkUrl,
      isRead: entity.isRead,
      created: entity.created.toIso8601String(),
    );
  }
}

class NotificationListModel {
  final int totalItem;
  final int pageIndex;
  final int pageCount;
  final List<NotificationModel> notificationList;

  const NotificationListModel({
    required this.totalItem,
    required this.pageIndex,
    required this.pageCount,
    required this.notificationList,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      totalItem: json['totalItem'] ?? 0,
      pageIndex: json['pageIndex'] ?? 1,
      pageCount: json['pageCount'] ?? 10,
      notificationList: json['notificationList'] != null
          ? (json['notificationList'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItem': totalItem,
      'pageIndex': pageIndex,
      'pageCount': pageCount,
      'notificationList': notificationList.map((item) => item.toJson()).toList(),
    };
  }

  NotificationListEntity toEntity() {
    return NotificationListEntity(
      totalItem: totalItem,
      pageIndex: pageIndex,
      pageCount: pageCount,
      notificationList: notificationList.map((item) => item.toEntity()).toList(),
    );
  }
}

class NotificationResponseModel {
  final bool success;
  final String message;
  final dynamic data; // Can be NotificationListModel or bool
  final List<String> errors;

  const NotificationResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'], // Keep as dynamic, will be handled in repository
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
    };
  }

  NotificationResponseEntity toEntity() {
    return NotificationResponseEntity(
      success: success,
      message: message,
      data: data,
      errors: errors,
    );
  }
}
