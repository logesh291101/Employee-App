class WorkTimeHistoryModel {
  final bool status;
  final String message;
  final String fromDate;
  final String toDate;
  final List<WorkTimeHistoryData> data;

  WorkTimeHistoryModel({
    required this.status,
    required this.message,
    required this.fromDate,
    required this.toDate,
    required this.data,
  });

  factory WorkTimeHistoryModel.fromJson(Map<String, dynamic> json) {
    return WorkTimeHistoryModel(
      status: _parseBool(json['status']),
      message: json['message']?.toString() ?? '',
      fromDate: json['from_date']?.toString() ?? '',
      toDate: json['to_date']?.toString() ?? '',
      data: _parseDataList(json['data']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  static List<WorkTimeHistoryData> _parseDataList(dynamic raw) {
    if (raw == null) return [];
    if (raw is Map) {
      return [
        WorkTimeHistoryData.fromJson(Map<String, dynamic>.from(raw)),
      ];
    }
    if (raw is! List) return [];

    final items = <WorkTimeHistoryData>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(
          WorkTimeHistoryData.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'from_date': fromDate,
      'to_date': toDate,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkTimeHistoryData {
  final String date;
  final String checkIn;
  final String? checkOut;
  final String workingHours;
  final String breakHours;

  WorkTimeHistoryData({
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.workingHours,
    required this.breakHours,
  });

  factory WorkTimeHistoryData.fromJson(Map<String, dynamic> json) {
    return WorkTimeHistoryData(
      date: json['date']?.toString() ?? '',
      checkIn: json['check_in']?.toString() ?? '',
      checkOut: json['check_out']?.toString(),
      workingHours: json['working_hours']?.toString() ?? '',
      breakHours: json['break_hours']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'check_in': checkIn,
      'check_out': checkOut,
      'working_hours': workingHours,
      'break_hours': breakHours,
    };
  }
}
