import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/account/get_user_profile_usecase.dart';
import '../../../domain/usecases/account/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
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

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    print('[ProfileBloc] Updating user profile...');
    emit(ProfileUpdateLoading());

    final params = UpdateUserProfileParams(
      userId: event.userId,
      request: event.request,
    );

    final result = await updateUserProfileUseCase(params);
    
    result.fold(
      (failure) {
        print('[ProfileBloc] Error updating profile: ${failure.message}');
        emit(ProfileUpdateError(failure.message));
      },
      (updatedProfile) {
        print('[ProfileBloc] Successfully updated profile: ${updatedProfile.fullname}');
        emit(ProfileUpdateSuccess(updatedProfile));
      },
    );
  }
}
