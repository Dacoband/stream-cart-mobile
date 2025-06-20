import 'package:equatable/equatable.dart';

class RegisterRequestEntity extends Equatable {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String fullname;
  final String? avatarURL;
  final int role;

  const RegisterRequestEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fullname,
    this.avatarURL,
    required this.role,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        phoneNumber,
        fullname,
        avatarURL,
        role,
      ];
}
