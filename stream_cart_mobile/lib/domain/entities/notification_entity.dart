import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
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
  final DateTime created;

  const NotificationEntity({
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

  NotificationEntity copyWith({
    String? notificationId,
    String? recipentUserId,
    String? orderCode,
    String? productId,
    String? variantId,
    String? livestreamId,
    String? type,
    String? message,
    String? linkUrl,
    bool? isRead,
    DateTime? created,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      recipentUserId: recipentUserId ?? this.recipentUserId,
      orderCode: orderCode ?? this.orderCode,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      livestreamId: livestreamId ?? this.livestreamId,
      type: type ?? this.type,
      message: message ?? this.message,
      linkUrl: linkUrl ?? this.linkUrl,
      isRead: isRead ?? this.isRead,
      created: created ?? this.created,
    );
  }

  @override
  List<Object?> get props => [
        notificationId,
        recipentUserId,
        orderCode,
        productId,
        variantId,
        livestreamId,
        type,
        message,
        linkUrl,
        isRead,
        created,
      ];
}

class NotificationListEntity extends Equatable {
  final int totalItem;
  final int pageIndex;
  final int pageCount;
  final List<NotificationEntity> notificationList;

  const NotificationListEntity({
    required this.totalItem,
    required this.pageIndex,
    required this.pageCount,
    required this.notificationList,
  });

  @override
  List<Object?> get props => [totalItem, pageIndex, pageCount, notificationList];
}

class NotificationResponseEntity extends Equatable {
  final bool success;
  final String message;
  final dynamic data; // Can be NotificationListEntity or bool (for mark as read)
  final List<String> errors;

  const NotificationResponseEntity({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  @override
  List<Object?> get props => [success, message, data, errors];
}
