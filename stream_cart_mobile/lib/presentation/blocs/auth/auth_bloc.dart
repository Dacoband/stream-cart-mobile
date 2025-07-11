import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/login_request_entity.dart';
import '../../../domain/entities/register_request_entity.dart';
import '../../../domain/entities/otp_entities.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../domain/usecases/otp_usecases.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
  }  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final loginRequest = LoginRequestEntity(
      username: event.username,
      password: event.password,
    );

    final result = await loginUseCase(loginRequest);

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null)!;
      
      if (failure.message == 'VERIFICATION_REQUIRED') {
        final email = await authRepository.getStoredUserEmail();
        if (email != null) {
          emit(AuthNeedsVerification(email: email));
        } else {
          emit(AuthFailure('Account requires verification. Please try again.'));
        }
      } else {
        emit(AuthFailure(failure.message));
      }
    } else {
      final loginResponse = result.fold((l) => null, (r) => r)!;
      if (loginResponse.account.isVerified) {
        emit(AuthSuccess(loginResponse));
      } else {
        emit(AuthNeedsVerification(email: loginResponse.account.email));
      }
    }
  }
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());

    final registerRequest = RegisterRequestEntity(
      username: event.username,
      email: event.email,
      password: event.password,
      phoneNumber: event.phoneNumber,
      fullname: event.fullname,
      avatarURL: event.avatarURL,
      role: event.role,
    );

    final result = await registerUseCase(registerRequest);

    result.fold(
      (failure) {
        emit(RegisterFailure(failure.message));
      },
      (registerResponse) {
        emit(RegisterSuccess(registerResponse));
      },
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpVerificationLoading());

    try {
      final accountId = await authRepository.getStoredAccountId();      if (accountId == null) {
        emit(OtpVerificationFailure('Account ID not found. Please register again.'));
        return;
      }

      final verifyRequest = VerifyOtpRequestEntity(
        accountId: accountId,
        otp: event.otp,
      );

      final result = await verifyOtpUseCase(verifyRequest);

      result.fold(
        (failure) {
          emit(OtpVerificationFailure(failure.message));
        },
        (otpResponse) {
          emit(OtpVerificationSuccess(otpResponse.message));
        },
      );
    } catch (e) {
      emit(OtpVerificationFailure('Unexpected error occurred'));
    }
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpResendLoading());

    final resendRequest = ResendOtpRequestEntity(
      email: event.email,
    );

    final result = await resendOtpUseCase(resendRequest);    result.fold(
      (failure) {
        emit(OtpResendFailure(failure.message));
      },
      (resendResponse) {
        emit(OtpResendSuccess(resendResponse.message));
      },
    );
  }
  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await authRepository.getStoredToken();
      final email = await authRepository.getStoredUserEmail();

      if (token != null && token.isNotEmpty) {
        if (email != null && email.isNotEmpty) {
          emit(AuthNeedsVerification(email: email));
        } else {
          emit(AuthAuthenticated(isVerified: true));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onRefreshToken(RefreshTokenEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await authRepository.refreshToken(event.refreshToken);
      result.fold(
        (failure) {
          emit(AuthUnauthenticated());
        },
        (loginResponse) {
          emit(AuthSuccess(loginResponse));
        },
      );
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
