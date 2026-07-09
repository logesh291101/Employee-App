class EIPModel {
  const EIPModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<EIPData> data;

  factory EIPModel.fromJson(Map<String, dynamic> json) {
    return EIPModel(
      status: _parseBool(json['status']),
      message: json['message']?.toString() ?? '',
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

  static List<EIPData> _parseDataList(dynamic raw) {
    if (raw == null) return [];
    if (raw is Map) {
      return [EIPData.fromJson(Map<String, dynamic>.from(raw))];
    }
    if (raw is! List) return [];

    final items = <EIPData>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(EIPData.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class EIPData {
  const EIPData({
    required this.employeeImpactPointId,
    required this.createdDate,
    required this.month,
    required this.points,
    required this.totalPointAllocated,
    required this.comments,
    required this.eipType,
  });

  final String employeeImpactPointId;
  final String createdDate;
  final String month;
  final String points;
  final String totalPointAllocated;
  final String comments;
  final String eipType;

  factory EIPData.fromJson(Map<String, dynamic> json) {
    return EIPData(
      employeeImpactPointId: _asString(json['employee_impact_point_id']),
      createdDate: _asString(json['created_date']),
      month: _asString(json['month']),
      points: _asString(json['points']),
      totalPointAllocated: _asString(json['total_point_allocated']),
      comments: _asString(json['comments']),
      eipType: _asString(json['eip_type']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_impact_point_id': employeeImpactPointId,
      'created_date': createdDate,
      'month': month,
      'points': points,
      'total_point_allocated': totalPointAllocated,
      'comments': comments,
      'eip_type': eipType,
    };
  }
}
