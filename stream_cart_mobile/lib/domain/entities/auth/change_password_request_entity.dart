class ChangePasswordRequestEntity {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequestEntity({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });
}
