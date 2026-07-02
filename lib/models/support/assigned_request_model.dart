 import 'package:employee_app/models/support/raised_request_model.dart';

class AssignedRequestModel {
  const AssignedRequestModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<AssignedRequestData> data;

  factory AssignedRequestModel.fromJson(Map<String, dynamic> json) {
    return AssignedRequestModel(
      status: _parseInt(json['status']),
      message: json['message']?.toString() ?? '',
      data: _parseDataList(json['data']),
    );
  }

  static List<AssignedRequestData> _parseDataList(dynamic raw) {
    if (raw == null) return [];
    if (raw is Map) {
      return [
        AssignedRequestData.fromJson(Map<String, dynamic>.from(raw)),
      ];
    }
    if (raw is! List) return [];

    final items = <AssignedRequestData>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(
          AssignedRequestData.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AssignedRequestData {
  const AssignedRequestData({
    required this.supportFormId,
    required this.requestUserId,
    required this.contactPersonId,
    required this.category,
    required this.subject,
    required this.description,
    required this.priority,
    required this.attachment,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.requestUser,
    required this.contactPerson,
    required this.categoryName,
  });

  final String supportFormId;
  final String requestUserId;
  final String contactPersonId;
  final String category;
  final String subject;
  final String description;
  final String priority;
  final String attachment;
  final String status;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final String requestUser;
  final String contactPerson;
  final String categoryName;

  factory AssignedRequestData.fromJson(Map<String, dynamic> json) {
    return AssignedRequestData(
      supportFormId: _asString(json['Supportformid']),
      requestUserId: _asString(json['requestuserid']),
      contactPersonId: _asString(json['contactpersonid']),
      category: _asString(json['Category']),
      subject: _asString(json['subject']),
      description: _asString(json['description']),
      priority: _asString(json['priority']),
      attachment: _asString(json['attachment']),
      status: _asString(json['status']),
      createdAt: _asString(json['created_at']),
      createdBy: _asString(json['createdby']),
      updatedAt: _asString(json['updated_at']),
      updatedBy: _asString(json['updatedby']),
      requestUser: _asString(json['requestuser']),
      contactPerson: _asString(json['contactperson']),
      categoryName: _asString(json['category_name']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  RaisedRequestData toRaisedRequestData() {
    return RaisedRequestData(
      supportFormId: supportFormId,
      requestUserId: requestUserId,
      contactPersonId: contactPersonId,
      category: category,
      subject: subject,
      description: description,
      priority: priority,
      attachment: attachment,
      status: status,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      requestUser: requestUser,
      contactPerson: contactPerson,
      categoryName: categoryName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Supportformid': supportFormId,
      'requestuserid': requestUserId,
      'contactpersonid': contactPersonId,
      'Category': category,
      'subject': subject,
      'description': description,
      'priority': priority,
      'attachment': attachment,
      'status': status,
      'created_at': createdAt,
      'createdby': createdBy,
      'updated_at': updatedAt,
      'updatedby': updatedBy,
      'requestuser': requestUser,
      'contactperson': contactPerson,
      'category_name': categoryName,
    };
  }
}
