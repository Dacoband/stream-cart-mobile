import 'package:dio/dio.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<LoginResponseModel> refreshToken(Map<String, String> refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final url = ApiUrlHelper.getAuthUrl(ApiConstants.loginEndpoint);
      final response = await dio.post(
        url,
        data: request.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }  @override
  Future<LoginResponseModel> refreshToken(Map<String, String> refreshToken) async {
    try {
      final url = ApiUrlHelper.getAuthUrl(ApiConstants.refreshTokenEndpoint);
      final response = await dio.post(
        url,
        data: refreshToken,
      );
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
