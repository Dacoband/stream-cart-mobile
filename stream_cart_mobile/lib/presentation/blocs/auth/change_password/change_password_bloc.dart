import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/auth/change_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase useCase;

  ChangePasswordBloc({required this.useCase}) : super(ChangePasswordInitial()) {
    on<SubmitChangePasswordEvent>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    // Basic client side validation
    if (event.request.newPassword != event.request.confirmNewPassword) {
      emit(ChangePasswordFailure('Mật khẩu mới và xác nhận không khớp'));
      return;
    }
    if (event.request.newPassword.length < 6) {
      emit(ChangePasswordFailure('Mật khẩu mới phải có ít nhất 6 ký tự'));
      return;
    }

    emit(ChangePasswordLoading());
    final result = await useCase(event.request);
    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message)),
      (response) {
        if (response.success) {
          emit(ChangePasswordSuccess(response));
        } else {
          emit(ChangePasswordFailure(response.message));
        }
      },
    );
  }
}
