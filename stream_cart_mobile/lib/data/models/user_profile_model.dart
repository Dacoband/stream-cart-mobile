import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
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

  const UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarURL: json['avatarURL'],
      role: json['role'] ?? 1,
      registrationDate: json['registrationDate'] ?? '',
      lastLoginDate: json['lastLoginDate'],
      isActive: json['isActive'] ?? true,
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

  UserProfileEntity toEntity() {
    return UserProfileEntity(
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

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      fullname: entity.fullname,
      avatarURL: entity.avatarURL,
      role: entity.role,
      registrationDate: entity.registrationDate.toIso8601String(),
      lastLoginDate: entity.lastLoginDate?.toIso8601String(),
      isActive: entity.isActive,
      isVerified: entity.isVerified,
      completeRate: entity.completeRate,
      shopId: entity.shopId,
      createdAt: entity.createdAt.toIso8601String(),
      createdBy: entity.createdBy,
      lastModifiedAt: entity.lastModifiedAt?.toIso8601String(),
      lastModifiedBy: entity.lastModifiedBy,
    );
  }
}
