class ChangePasswordResponseEntity {
  final bool success;
  final String message;
  final bool? data; // API returns data: true on success (per swagger screenshot)
  final List<String>? errors;

  ChangePasswordResponseEntity({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });
}
