import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfileEvent extends ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfileEntity profile;

  const UpdateUserProfileEvent(this.profile);

  @override
  List<Object> get props => [profile];
}
