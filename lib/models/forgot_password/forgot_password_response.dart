class ForgotPasswordResponse {
  const ForgotPasswordResponse({
    required this.status,
    required this.message,
  });

  final int status;
  final String message;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      message: json['message'] as String? ?? '',
    );
  }
}
