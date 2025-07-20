import 'package:equatable/equatable.dart';
import '../../../data/models/update_profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfileEvent extends ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final String userId;
  final UpdateProfileRequestModel request;

  const UpdateUserProfileEvent({
    required this.userId,
    required this.request,
  });

  @override
  List<Object> get props => [userId, request];
}
