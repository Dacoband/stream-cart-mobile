import 'package:equatable/equatable.dart';

class LoginRequestEntity extends Equatable {
  final String username;
  final String password;

  const LoginRequestEntity({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
