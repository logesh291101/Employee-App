import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/support/department_dropdown_model.dart';
import 'package:employee_app/models/support/staff_dropdown_model.dart';
import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/models/support/raised_request_model.dart';
import 'package:employee_app/models/support/support_form_models.dart';
import 'package:employee_app/services/support_form_service.dart';

class SupportFormRepository {
  SupportFormRepository(this._supportFormService);

  final SupportFormService _supportFormService;

  Future<List<DepartmentDropDownModel>> getDepartments() async {
    try {
      return await _supportFormService.getDepartments();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<List<StaffDropDownModel>> getStaffs(int departmentId) async {
    try {
      return await _supportFormService.getStaffs(departmentId);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<RaisedRequestModel> getMyRequests() async {
    try {
      return await _supportFormService.getMyRequests();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<AssignedRequestModel> getAssignedRequests() async {
    try {
      return await _supportFormService.getAssignedRequests();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<CreateSupportResponse> updateSupportStatus({
    required int supportFormId,
    required int status,
  }) async {
    try {
      return await _supportFormService.updateSupportStatus(
        supportFormId: supportFormId,
        status: status,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<CreateSupportResponse> createSupportRequest({
    required int requestUserId,
    required int contactPersonId,
    required int category,
    required String subject,
    required String description,
    required String priority,
    String? attachment,
  }) async {
    try {
      return await _supportFormService.createSupportRequest(
        CreateSupportRequestBody(
          requestUserId: requestUserId,
          contactPersonId: contactPersonId,
          category: category,
          subject: subject,
          description: description,
          priority: priority,
          attachment: attachment,
        ),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
