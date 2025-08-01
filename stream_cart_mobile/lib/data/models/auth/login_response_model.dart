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
  final Map<String, dynamic>? rawData; // Add this to store raw data

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.rawData, // Add this parameter
  });  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && json['success'] == true
          ? LoginResponseDataModel.fromJson(json['data'])
          : null,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors'])
          : null,
      rawData: json['data'] as Map<String, dynamic>?, // Store raw data
    );
  }
  Map<String, dynamic> toJson() {
    // Need to access original JSON data for verification cases
    // For now, construct the map with available data
    final Map<String, dynamic> result = {
      'success': success,
      'message': message,
      'errors': errors,
    };
    
    if (data != null) {
      result['data'] = data!.toJson();
    } else {
      // If data is null but we need to preserve original structure for error cases
      result['data'] = null;
    }
    
    return result;
  }
}
