import 'package:employee_app/models/support/department_dropdown_model.dart';
import 'package:employee_app/models/support/staff_dropdown_model.dart';

class DepartmentsResponse {
  const DepartmentsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<DepartmentDropDownModel> data;
}

class StaffsResponse {
  const StaffsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<StaffDropDownModel> data;
}

class CreateSupportRequestBody {
  const CreateSupportRequestBody({
    required this.requestUserId,
    required this.contactPersonId,
    required this.category,
    required this.subject,
    required this.description,
    required this.priority,
    this.attachment,
  });

  final int requestUserId;
  final int contactPersonId;
  final int category;
  final String subject;
  final String description;
  final String priority;
  final String? attachment;

  Map<String, dynamic> toJson() {
    return {
      'requestuserid': requestUserId,
      'contactpersonid': contactPersonId,
      'Category': category,
      'subject': subject,
      'description': description,
      'priority': priority,
      if (attachment != null && attachment!.isNotEmpty)
        'attachment': attachment,
    };
  }
}

class CreateSupportResponse {
  const CreateSupportResponse({
    required this.status,
    required this.message,
    this.supportFormId,
  });

  final int status;
  final String message;
  final int? supportFormId;

  factory CreateSupportResponse.fromJson(Map<String, dynamic> json) {
    final supportFormId = json['supportformid'];
    return CreateSupportResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      message: json['message'] as String? ?? '',
      supportFormId: supportFormId is int
          ? supportFormId
          : int.tryParse('$supportFormId'),
    );
  }
}
