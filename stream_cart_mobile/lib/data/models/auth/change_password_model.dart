import '../../../domain/entities/auth/change_password_request_entity.dart';
import '../../../domain/entities/auth/change_password_response_entity.dart';

class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
  // Include both camelCase and PascalCase just in case backend binder is strict/custom
  'currentPassword': currentPassword,
  'newPassword': newPassword,
  'confirmNewPassword': confirmNewPassword,
  'CurrentPassword': currentPassword,
  'NewPassword': newPassword,
  'ConfirmNewPassword': confirmNewPassword,
      };

  factory ChangePasswordRequestModel.fromEntity(ChangePasswordRequestEntity e) => ChangePasswordRequestModel(
        currentPassword: e.currentPassword,
        newPassword: e.newPassword,
        confirmNewPassword: e.confirmNewPassword,
      );
}

class ChangePasswordResponseModel {
  final bool success;
  final String message;
  final bool? data;
  final List<String>? errors;

  ChangePasswordResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) => ChangePasswordResponseModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] is bool ? json['data'] as bool : null,
        errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
      );

  ChangePasswordResponseEntity toEntity() => ChangePasswordResponseEntity(
        success: success,
        message: message,
        data: data,
        errors: errors,
      );
}
