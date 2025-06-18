import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
  }
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    print('AuthBloc: Login event received');
    emit(AuthLoading());

    final loginRequest = LoginRequestEntity(
      username: event.username,
      password: event.password,
    );

    print('AuthBloc: Calling login use case');
    final result = await loginUseCase(loginRequest);

    result.fold(
      (failure) {
        print('AuthBloc: Login failed - ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (loginResponse) {
        print('AuthBloc: Login successful - ${loginResponse.account.username}');
        emit(AuthSuccess(loginResponse));
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }

  Future<void> _onRefreshToken(RefreshTokenEvent event, Emitter<AuthState> emit) async {
    // TODO: Implement refresh token logic
  }
}
