class AttendanceTodayModel {
  const AttendanceTodayModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final AttendanceTodayData data;

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AttendanceTodayModel(
      status: _parseAttendanceStatus(json['status']),
      message: json['message']?.toString() ?? '',
      data: rawData is Map
          ? AttendanceTodayData.fromJson(Map<String, dynamic>.from(rawData))
          : const AttendanceTodayData(),
    );
  }

  static bool _parseAttendanceStatus(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}

class AttendanceTodayData {
  const AttendanceTodayData({
    this.checkInTime = '',
    this.checkOutTime = '',
    this.totalWorkHours = '',
    this.breaks = const [],
  });

  final String checkInTime;
  final String checkOutTime;
  final String totalWorkHours;
  final List<BreakRecord> breaks;

  factory AttendanceTodayData.fromJson(Map<String, dynamic> json) {
    return AttendanceTodayData(
      checkInTime: _attendanceField(json, [
        'check_in_time',
        'check_in',
        'checkin_time',
        'checkin',
      ]),
      checkOutTime: _attendanceField(json, [
        'check_out_time',
        'check_out',
        'checkout_time',
        'checkout',
      ]),
      totalWorkHours: _attendanceField(json, [
        'total_work_hours',
        'total_hours',
        'total_hour',
        'work_hours',
        'working_time',
      ]),
      breaks: _parseBreaks(json['breaks'] ?? json['break_list'] ?? json['break_data']),
    );
  }

  static String _attendanceField(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  static List<BreakRecord> _parseBreaks(dynamic raw) {
    if (raw == null) return [];
    if (raw is! List) return [];

    final items = <BreakRecord>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(BreakRecord.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }
}

class BreakRecord {
  const BreakRecord({
    this.startTime = '',
    this.duration = '',
    this.endTime = '',
  });

  final String startTime;
  final String duration;
  final String endTime;

  factory BreakRecord.fromJson(Map<String, dynamic> json) {
    return BreakRecord(
      startTime: AttendanceTodayData._attendanceField(json, [
        'start_time',
        'break_start_time',
        'break_start',
        'start',
      ]),
      duration: AttendanceTodayData._attendanceField(json, [
        'duration',
        'break_duration',
        'break_time',
        'total_duration',
      ]),
      endTime: AttendanceTodayData._attendanceField(json, [
        'end_time',
        'break_end_time',
        'break_end',
        'end',
      ]),
    );
  }
}
