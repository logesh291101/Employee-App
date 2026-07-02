class LoginRequest {
  const LoginRequest({
    required this.emNo,
    required this.password,
  });

  final String emNo;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'emNo': emNo,
      'password': password,
    };
  }
}
