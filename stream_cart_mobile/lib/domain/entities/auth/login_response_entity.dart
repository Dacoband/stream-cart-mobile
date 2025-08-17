import 'package:equatable/equatable.dart';
import '../account/account_entity.dart';

class LoginResponseEntity extends Equatable {
  final bool success;
  final String token;
  final String refreshToken;
  final AccountEntity account;
  final String message;

  const LoginResponseEntity({
    required this.success,
    required this.token,
    required this.refreshToken,
    required this.account,
    required this.message,
  });

  @override
  List<Object?> get props => [success, token, refreshToken, account, message];
}
