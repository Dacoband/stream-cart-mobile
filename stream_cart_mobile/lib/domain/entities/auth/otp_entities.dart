import 'package:equatable/equatable.dart';

class VerifyOtpRequestEntity extends Equatable {
  final String accountId; // Changed from email to accountId
  final String otp;

  const VerifyOtpRequestEntity({
    required this.accountId,
    required this.otp,
  });

  @override
  List<Object?> get props => [accountId, otp];
}

class VerifyOtpResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<String>? errors;

  const VerifyOtpResponseEntity({
    required this.success,
    required this.message,
    this.errors,
  });

  @override
  List<Object?> get props => [success, message, errors];
}

class ResendOtpRequestEntity extends Equatable {
  final String email;

  const ResendOtpRequestEntity({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ResendOtpResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<String>? errors;

  const ResendOtpResponseEntity({
    required this.success,
    required this.message,
    this.errors,
  });

  @override
  List<Object?> get props => [success, message, errors];
}
