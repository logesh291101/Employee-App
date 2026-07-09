class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  final String email;
  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
