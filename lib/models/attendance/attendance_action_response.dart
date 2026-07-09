bool parseAttendanceStatus(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}

String attendanceResponseField(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return '';
}

class AttendanceActionResponse {
  const AttendanceActionResponse({
    required this.status,
    required this.action,
    required this.message,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workingTime,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.breakTime,
  });

  final bool status;
  final String action;
  final String message;
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final String workingTime;
  final String breakStartTime;
  final String breakEndTime;
  final String breakTime;

  factory AttendanceActionResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceActionResponse(
      status: parseAttendanceStatus(json['status']),
      action: json['action']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      checkInTime: attendanceResponseField(json, ['check_in_time']),
      checkOutTime: attendanceResponseField(json, ['check_out_time']),
      workingTime: attendanceResponseField(json, ['working_time']),
      breakStartTime: attendanceResponseField(json, ['break_start_time']),
      breakEndTime: attendanceResponseField(json, ['break_end_time']),
      breakTime: attendanceResponseField(json, ['break_time']),
    );
  }
}
