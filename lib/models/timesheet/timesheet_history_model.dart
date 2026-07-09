class TimeSheetHistoryModel {
  const TimeSheetHistoryModel({
    required this.status,
    required this.message,
    required this.fromDate,
    required this.toDate,
    required this.data,
  });

  final bool status;
  final String message;
  final String fromDate;
  final String toDate;
  final List<TimeSheetHistoryData> data;

  factory TimeSheetHistoryModel.fromJson(Map<String, dynamic> json) {
    return TimeSheetHistoryModel(
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

  static List<TimeSheetHistoryData> _parseDataList(dynamic raw) {
    if (raw == null) return [];
    if (raw is Map) {
      return [
        TimeSheetHistoryData.fromJson(Map<String, dynamic>.from(raw)),
      ];
    }
    if (raw is! List) return [];

    final items = <TimeSheetHistoryData>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(
          TimeSheetHistoryData.fromJson(Map<String, dynamic>.from(item)),
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

class TimeSheetHistoryData {
  const TimeSheetHistoryData({
    required this.staffTimesheetId,
    required this.staffId,
    required this.taskDate,
    required this.staffTask,
    required this.taskTakenTime,
    required this.taskDesc,
    this.reviewComment,
    required this.createdDate,
    required this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.taskTakenTime1,
    required this.counter,
  });

  final String staffTimesheetId;
  final String staffId;
  final String taskDate;
  final String staffTask;
  final String taskTakenTime;
  final String taskDesc;
  final String? reviewComment;
  final String createdDate;
  final String createdBy;
  final String? updatedDate;
  final String? updatedBy;
  final String? taskTakenTime1;
  final String counter;

  factory TimeSheetHistoryData.fromJson(Map<String, dynamic> json) {
    return TimeSheetHistoryData(
      staffTimesheetId: _asString(json['staff_timesheet_id']),
      staffId: _asString(json['staff_id']),
      taskDate: _asString(json['task_date']),
      staffTask: _asString(json['staff_task']),
      taskTakenTime: _asString(json['task_taken_time']),
      taskDesc: _asString(json['task_desc']),
      reviewComment: json['review_comment']?.toString(),
      createdDate: _asString(json['created_date']),
      createdBy: _asString(json['created_by']),
      updatedDate: json['updated_date']?.toString(),
      updatedBy: json['updated_by']?.toString(),
      taskTakenTime1: json['task_taken_time1']?.toString(),
      counter: _asString(json['counter']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_timesheet_id': staffTimesheetId,
      'staff_id': staffId,
      'task_date': taskDate,
      'staff_task': staffTask,
      'task_taken_time': taskTakenTime,
      'task_desc': taskDesc,
      'review_comment': reviewComment,
      'created_date': createdDate,
      'created_by': createdBy,
      'updated_date': updatedDate,
      'updated_by': updatedBy,
      'task_taken_time1': taskTakenTime1,
      'counter': counter,
    };
  }
}
