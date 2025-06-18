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

class LogoutEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}
