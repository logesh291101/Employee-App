class ForgotPasswordRequest {
  const ForgotPasswordRequest({
    required this.emNo,
    required this.email,
  });

  final String emNo;
  final String email;

  Map<String, dynamic> toJson() {
    return {
      'emNo': emNo,
      'email': email,
    };
  }
}
