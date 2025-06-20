import 'package:dio/dio.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/otp_models.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/api_url_helper.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel request);
  Future<LoginResponseModel> refreshToken(Map<String, String> refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = ApiUrlHelper.getAuthUrl(ApiConstants.loginEndpoint);
    final response = await dio.post(url, data: request.toJson());
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final url = ApiUrlHelper.getAuthUrl(ApiConstants.signupEndpoint);
    final response = await dio.post(url, data: request.toJson());
    return RegisterResponseModel.fromJson(response.data);
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    final url = ApiUrlHelper.getAuthUrl(ApiConstants.verifyOtpEndpoint);
    final response = await dio.post(url, data: request.toJson());
    return VerifyOtpResponseModel.fromJson(response.data);
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel request) async {
    final url = ApiUrlHelper.getAuthUrl(ApiConstants.resendOtpEndpoint);
    final response = await dio.post(url, data: request.toJson());
    return ResendOtpResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> refreshToken(Map<String, String> refreshToken) async {
    final url = ApiUrlHelper.getAuthUrl(ApiConstants.refreshTokenEndpoint);
    final response = await dio.post(url, data: refreshToken);
    return LoginResponseModel.fromJson(response.data);
  }
}
