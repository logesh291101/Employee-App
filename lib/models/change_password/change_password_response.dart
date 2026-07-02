class ChangePasswordResponse {
  const ChangePasswordResponse({
    required this.status,
    required this.message,
  });

  final int status;
  final String message;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      message: json['message'] as String? ?? '',
    );
  }
}
