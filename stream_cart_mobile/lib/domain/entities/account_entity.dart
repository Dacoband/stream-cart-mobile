import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
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

  const AccountEntity({
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
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        phoneNumber,
        fullname,
        avatarURL,
        role,
        registrationDate,
        lastLoginDate,
        isActive,
        isVerified,
        completeRate,
        shopId,
        createdAt,
        createdBy,
        lastModifiedAt,
        lastModifiedBy,
      ];
}
