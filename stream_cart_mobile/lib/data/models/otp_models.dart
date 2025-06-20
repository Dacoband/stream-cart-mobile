import '../../domain/entities/otp_entities.dart';

class VerifyOtpRequestModel {
  final String accountId; // Changed from email to accountId
  final String otp;

  const VerifyOtpRequestModel({
    required this.accountId,
    required this.otp,
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      accountId: json['accountId'] ?? '',
      otp: json['otp'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId, // Use accountId as per API docs
      'otp': otp,
    };
  }

  factory VerifyOtpRequestModel.fromEntity(VerifyOtpRequestEntity entity) {
    return VerifyOtpRequestModel(
      accountId: entity.accountId,
      otp: entity.otp,
    );
  }

  VerifyOtpRequestEntity toEntity() {
    return VerifyOtpRequestEntity(
      accountId: accountId,
      otp: otp,
    );
  }
}

class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final List<String>? errors;

  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'errors': errors,
    };
  }

  VerifyOtpResponseEntity toEntity() {
    return VerifyOtpResponseEntity(
      success: success,
      message: message,
      errors: errors,
    );
  }
}

class ResendOtpRequestModel {
  final String email;

  const ResendOtpRequestModel({
    required this.email,
  });

  factory ResendOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpRequestModel(
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
  factory ResendOtpRequestModel.fromEntity(ResendOtpRequestEntity entity) {
    return ResendOtpRequestModel(
      email: entity.email,
    );
  }
  ResendOtpRequestEntity toEntity() {
    return ResendOtpRequestEntity(
      email: email,
    );
  }
}

class ResendOtpResponseModel {
  final bool success;
  final String message;
  final List<String>? errors;

  const ResendOtpResponseModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'errors': errors,
    };
  }

  ResendOtpResponseEntity toEntity() {
    return ResendOtpResponseEntity(
      success: success,
      message: message,
      errors: errors,
    );
  }
}
