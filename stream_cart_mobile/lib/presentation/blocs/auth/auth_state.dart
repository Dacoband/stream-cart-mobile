import 'package:equatable/equatable.dart';
import '../../../domain/entities/login_response_entity.dart';
import '../../../domain/entities/register_response_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Login States
class AuthSuccess extends AuthState {
  final LoginResponseEntity loginResponse;

  const AuthSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Registration States
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final RegisterResponseEntity registerResponse;

  const RegisterSuccess(this.registerResponse);

  @override
  List<Object?> get props => [registerResponse];
}

class RegisterFailure extends AuthState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// OTP Verification States
class OtpVerificationLoading extends AuthState {}

class OtpVerificationSuccess extends AuthState {
  final String message;

  const OtpVerificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpVerificationFailure extends AuthState {
  final String message;

  const OtpVerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// OTP Resend States
class OtpResendLoading extends AuthState {}

class OtpResendSuccess extends AuthState {
  final String message;

  const OtpResendSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpResendFailure extends AuthState {
  final String message;

  const OtpResendFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Auth Status States
class AuthAuthenticated extends AuthState {
  final bool isVerified;

  const AuthAuthenticated({required this.isVerified});

  @override
  List<Object?> get props => [isVerified];
}

class AuthUnauthenticated extends AuthState {}

class AuthNeedsVerification extends AuthState {
  final String email;

  const AuthNeedsVerification({required this.email});

  @override
  List<Object?> get props => [email];
}
