import 'package:dio/dio.dart';
import '../../../core/utils/api_url_helper.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/notification/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationResponseModel> getNotifications({
    String? type,
    bool? isRead,
    int? pageIndex,
    int? pageSize,
  });

  Future<NotificationResponseModel> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<NotificationResponseModel> getNotifications({
    String? type,
    bool? isRead,
    int? pageIndex,
    int? pageSize,
  }) async {
    final url = ApiUrlHelper.getFullUrl(ApiConstants.notificationEndpoint);
    
    // Build query parameters
    final Map<String, dynamic> queryParameters = {};
    if (type != null) queryParameters['Type'] = type;
    if (isRead != null) queryParameters['IsRead'] = isRead;
    if (pageIndex != null) queryParameters['PageIndex'] = pageIndex;
    if (pageSize != null) queryParameters['PageSize'] = pageSize;

    final response = await dio.get(
      url,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    return NotificationResponseModel.fromJson(response.data);
  }

  @override
  Future<NotificationResponseModel> markAsRead(String notificationId) async {
    final url = ApiUrlHelper.getFullUrl('${ApiConstants.markAsReadEndpoint}/$notificationId');
    
    final response = await dio.patch(url);
    return NotificationResponseModel.fromJson(response.data);
  }
}
