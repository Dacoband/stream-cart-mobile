import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String fullname;
  final String? avatarURL;
  final int role;

  const RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fullname,
    this.avatarURL,
    required this.role,
  });

  @override
  List<Object?> get props => [username, email, password, phoneNumber, fullname, avatarURL, role];
}

class VerifyOtpEvent extends AuthEvent {
  final String email; // Keep email for UI convenience
  final String otp;

  const VerifyOtpEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LogoutEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}
