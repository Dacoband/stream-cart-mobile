import '../../domain/entities/user_profile_entity.dart';
import 'user_profile_model.dart';

class UpdateProfileRequestModel {
  final String phoneNumber;
  final String fullname;
  final String? avatarURL;
  final int role;
  final bool isActive;
  final bool isVerified;
  final double completeRate;
  final String? shopId;

  const UpdateProfileRequestModel({
    required this.phoneNumber,
    required this.fullname,
    this.avatarURL,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.completeRate,
    this.shopId,
  });

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequestModel(
      phoneNumber: json['phoneNumber'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarURL: json['avatarURL'],
      role: json['role'] ?? 1,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      completeRate: (json['completeRate'] ?? 0).toDouble(),
      shopId: json['shopId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'fullname': fullname,
      'avatarURL': avatarURL,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'completeRate': completeRate,
      'shopId': shopId,
    };
  }

  factory UpdateProfileRequestModel.fromEntity(UserProfileEntity entity) {
    return UpdateProfileRequestModel(
      phoneNumber: entity.phoneNumber,
      fullname: entity.fullname,
      avatarURL: entity.avatarURL,
      role: entity.role,
      isActive: entity.isActive,
      isVerified: entity.isVerified,
      completeRate: entity.completeRate,
      shopId: entity.shopId,
    );
  }
}

class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final UserProfileModel? data;
  final List<String>? errors;

  const UpdateProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserProfileModel.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
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
