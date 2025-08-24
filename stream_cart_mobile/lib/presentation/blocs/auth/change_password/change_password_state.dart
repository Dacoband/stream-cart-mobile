import '../../../../domain/entities/auth/change_password_response_entity.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}
class ChangePasswordLoading extends ChangePasswordState {}
class ChangePasswordSuccess extends ChangePasswordState {
  final ChangePasswordResponseEntity response;
  ChangePasswordSuccess(this.response);
}
class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  ChangePasswordFailure(this.message);
}
