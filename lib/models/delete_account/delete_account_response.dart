class DeleteAccountResponse {
  const DeleteAccountResponse({
    required this.status,
    required this.message,
  });

  final int status;
  final String message;

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      message: json['message'] as String? ?? '',
    );
  }
}
