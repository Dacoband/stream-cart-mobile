import '../../../../domain/entities/auth/change_password_request_entity.dart';

abstract class ChangePasswordEvent {}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final ChangePasswordRequestEntity request;
  SubmitChangePasswordEvent(this.request);
}
