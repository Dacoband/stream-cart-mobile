import '../../domain/entities/login_response_entity.dart';
import 'account_model.dart';

class LoginResponseDataModel {
  final bool success;
  final String token;
  final String refreshToken;
  final AccountModel account;
  final String message;

  LoginResponseDataModel({
    required this.success,
    required this.token,
    required this.refreshToken,
    required this.account,
    required this.message,
  });

  factory LoginResponseDataModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseDataModel(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      account: AccountModel.fromJson(json['account'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'refreshToken': refreshToken,
      'account': account.toJson(),
      'message': message,
    };
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      success: success,
      token: token,
      refreshToken: refreshToken,
      account: account.toEntity(),
      message: message,
    );
  }
}

class LoginResponseModel {
  final bool success;
  final String message;
  final LoginResponseDataModel? data;
  final List<String>? errors;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? LoginResponseDataModel.fromJson(json['data'])
          : null,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}
