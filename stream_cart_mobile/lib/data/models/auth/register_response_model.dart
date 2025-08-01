import '../../../domain/entities/auth/register_response_entity.dart';

class RegisterResponseModel {
  final bool success;
  final String message;
  final RegisteredUserModel? data;
  final List<String>? errors;

  const RegisterResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisteredUserModel.fromJson(json['data']) : null,
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

  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      success: success,
      message: message,
      data: data?.toEntity(),
      errors: errors,
    );
  }
}

class RegisteredUserModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String fullname;
  final String? avatarURL;
  final int role;
  final String registrationDate;
  final String? lastLoginDate;
  final bool isActive;
  final bool isVerified;
  final double completeRate;
  final String? shopId;
  final String createdAt;
  final String? createdBy;
  final String? lastModifiedAt;
  final String? lastModifiedBy;

  const RegisteredUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.fullname,
    this.avatarURL,
    required this.role,
    required this.registrationDate,
    this.lastLoginDate,
    required this.isActive,
    required this.isVerified,
    required this.completeRate,
    this.shopId,
    required this.createdAt,
    this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarURL: json['avatarURL'],
      role: json['role'] ?? 0,
      registrationDate: json['registrationDate'] ?? '',
      lastLoginDate: json['lastLoginDate'],
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      completeRate: (json['completeRate'] ?? 0).toDouble(),
      shopId: json['shopId'],
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'],
      lastModifiedAt: json['lastModifiedAt'],
      lastModifiedBy: json['lastModifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullname': fullname,
      'avatarURL': avatarURL,
      'role': role,
      'registrationDate': registrationDate,
      'lastLoginDate': lastLoginDate,
      'isActive': isActive,
      'isVerified': isVerified,
      'completeRate': completeRate,
      'shopId': shopId,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt,
      'lastModifiedBy': lastModifiedBy,
    };
  }

  RegisteredUserEntity toEntity() {
    return RegisteredUserEntity(
      id: id,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      fullname: fullname,
      avatarURL: avatarURL,
      role: role,
      registrationDate: DateTime.tryParse(registrationDate) ?? DateTime.now(),
      lastLoginDate: lastLoginDate != null ? DateTime.tryParse(lastLoginDate!) : null,
      isActive: isActive,
      isVerified: isVerified,
      completeRate: completeRate,
      shopId: shopId,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt != null ? DateTime.tryParse(lastModifiedAt!) : null,
      lastModifiedBy: lastModifiedBy,
    );
  }
}
