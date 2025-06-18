import '../../domain/entities/account_entity.dart';

class AccountModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String fullname;
  final String avatarURL;
  final int role;
  final DateTime registrationDate;
  final DateTime lastLoginDate;
  final bool isActive;
  final bool isVerified;
  final double completeRate;
  final String? shopId;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastModifiedAt;
  final String? lastModifiedBy;

  AccountModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.fullname,
    required this.avatarURL,
    required this.role,
    required this.registrationDate,
    required this.lastLoginDate,
    required this.isActive,
    required this.isVerified,
    required this.completeRate,
    this.shopId,
    required this.createdAt,
    required this.createdBy,
    this.lastModifiedAt,
    this.lastModifiedBy,
  });  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarURL: json['avatarURL'] ?? '',
      role: json['role'] ?? 0,
      registrationDate: DateTime.parse(json['registrationDate'] ?? DateTime.now().toIso8601String()),
      lastLoginDate: DateTime.parse(json['lastLoginDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      completeRate: (json['completeRate'] ?? 0).toDouble(),
      shopId: json['shopId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      createdBy: json['createdBy'] ?? '',
      lastModifiedAt: json['lastModifiedAt'] != null 
          ? DateTime.parse(json['lastModifiedAt']) 
          : null,
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
      'registrationDate': registrationDate.toIso8601String(),
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'isActive': isActive,
      'isVerified': isVerified,
      'completeRate': completeRate,
      'shopId': shopId,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }
  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      fullname: fullname,
      avatarURL: avatarURL,
      role: role,
      registrationDate: registrationDate,
      lastLoginDate: lastLoginDate,
      isActive: isActive,
      isVerified: isVerified,
      completeRate: completeRate,
      shopId: shopId,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt,
      lastModifiedBy: lastModifiedBy,
    );
  }
}
