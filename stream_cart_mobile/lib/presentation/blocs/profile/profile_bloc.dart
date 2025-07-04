import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    print('[ProfileBloc] Loading user profile...');
    emit(ProfileLoading());

    final result = await getUserProfileUseCase();
    
    result.fold(
      (failure) {
        print('[ProfileBloc] Error loading profile: ${failure.message}');
        // Check if it's an authentication error
        if (failure.message.contains('401') || failure.message.contains('Unauthorized')) {
          emit(ProfileError('Vui lòng đăng nhập lại để xem thông tin cá nhân'));
        } else {
          emit(ProfileError(failure.message));
        }
      },
      (profile) {
        print('[ProfileBloc] Successfully loaded profile: ${profile.fullname}');
        emit(ProfileLoaded(profile));
      },
    );
  }
}
