import '../../domain/entities/register_request_entity.dart';

class RegisterRequestModel {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String fullname;
  final String? avatarURL;
  final String role; // Changed from int to String

  const RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fullname,
    this.avatarURL,
    required this.role,
  });
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarURL: json['avatarURL'],
      role: json['role']?.toString() ?? '0',
    );
  }  Map<String, dynamic> toJson() {
    // Try sending data directly without createAccountDto wrapper
    return {
      'username': username,        // PascalCase
      'email': email,             // PascalCase
      'password': password,       // PascalCase
      'phoneNumber': phoneNumber, // PascalCase
      'fullname': fullname,       // PascalCase
      'role': int.tryParse(role) ?? 0, // PascalCase - 0 for Customer, 1 for Seller
      if (avatarURL != null) 'avatarURL': avatarURL, // PascalCase
    };
  }
  factory RegisterRequestModel.fromEntity(RegisterRequestEntity entity) {
    return RegisterRequestModel(
      username: entity.username,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      fullname: entity.fullname,
      avatarURL: entity.avatarURL,
      role: entity.role.toString(), // Convert int to String
    );
  }

  RegisterRequestEntity toEntity() {
    return RegisterRequestEntity(
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      fullname: fullname,
      avatarURL: avatarURL,
      role: int.tryParse(role) ?? 0, // Convert String to int
    );
  }
}
