class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.emNo,
    required this.currentPassword,
    required this.newPassword,
  });

  final String emNo;
  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'emNo': emNo,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
