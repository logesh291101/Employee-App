import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/support/department_dropdown_model.dart';
import 'package:employee_app/models/support/staff_dropdown_model.dart';
import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/models/support/raised_request_model.dart';
import 'package:employee_app/models/support/support_form_models.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class SupportFormService {
  SupportFormService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<List<DepartmentDropDownModel>> getDepartments() async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final uri = _buildUri(liveUrl, 'supportform/departments');

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      return _parseDepartmentList(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<List<StaffDropDownModel>> getStaffs(int departmentId) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }
    final uri = _buildUri(liveUrl, 'supportform/staffs');
    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'departmentid': departmentId}),
          )
          .timeout(_timeout);

      return _parseStaffList(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
  Future<RaisedRequestModel> getMyRequests() async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }
    final staffId = await SharedPrefHelper.getStaffId();
    if (staffId.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }
    final uri = _buildUri(
      liveUrl,
      'supportform/requestuser',
    ).replace(queryParameters: {'requestUserId': staffId});
    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      return _parseMyRequestsResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
  Future<AssignedRequestModel> getAssignedRequests() async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }
    final staffId = await SharedPrefHelper.getStaffId();
    if (staffId.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final uri = _buildUri(
      liveUrl,
      'supportform/contactperson',
    ).replace(queryParameters: {'contactPersonId': staffId});

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      return _parseAssignedRequestsResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<CreateSupportResponse> updateSupportStatus({
    required int supportFormId,
    required int status,
  }) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final staffId = await SharedPrefHelper.getStaffId();
    if (staffId.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final staffIdInt = int.tryParse(staffId);
    if (staffIdInt == null) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final uri = _buildUri(
      liveUrl,
      'supportform/updatestatus',
    );

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'supportformid': supportFormId,
              'status': status,
              'staff_id': staffIdInt,
            }),
          )
          .timeout(_timeout);

      return _parseUpdateStatusResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<CreateSupportResponse> createSupportRequest(
    CreateSupportRequestBody request,
  ) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final uri = _buildUri(liveUrl, 'supportform/create');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);

      return _parseCreateResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException('Unexpected response from server. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Uri _buildUri(String liveUrl, String path) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse('$normalized$path');
  }

  List<DepartmentDropDownModel> _parseDepartmentList(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      final status = _parseStatus(body['status']);
      if (status == 1) {
        final data = body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(DepartmentDropDownModel.fromJson)
              .toList();
        }
        throw ApiException(
          'Unexpected response from server. Please try again.',
        );
      }

      throw ApiException(
        apiMessage?.isNotEmpty == true
            ? apiMessage!
            : 'Failed to fetch departments. Please try again.',
      );
    }

    throw _httpError(response.statusCode, apiMessage, 'departments');
  }

  List<StaffDropDownModel> _parseStaffList(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      log("-----{$body},${response}");
      final status = _parseStatus(body['status']);
      if (status == 1) {
        final data = body['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(StaffDropDownModel.fromJson)
              .toList();
        }
        throw ApiException(
          'Unexpected response from server. Please try again.',
        );
      }

      throw ApiException(
        apiMessage?.isNotEmpty == true
            ? apiMessage!
            : 'Failed to fetch staff. Please try again.',
      );
    }

    throw _httpError(response.statusCode, apiMessage, 'staff');
  }

  CreateSupportResponse _parseCreateResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      final apiResponse = CreateSupportResponse.fromJson(body);
      if (apiResponse.status == 1) {
        return apiResponse;
      }

      throw ApiException(
        apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Failed to create support request. Please try again.',
      );
    }

    throw _httpError(response.statusCode, apiMessage, 'support request');
  }

  RaisedRequestModel _parseMyRequestsResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      return RaisedRequestModel.fromJson(body);
    }

    throw _httpError(response.statusCode, apiMessage, 'support requests');
  }

  AssignedRequestModel _parseAssignedRequestsResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      return AssignedRequestModel.fromJson(body);
    }

    throw _httpError(
      response.statusCode,
      apiMessage,
      'assigned support requests',
    );
  }

  CreateSupportResponse _parseUpdateStatusResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      final apiResponse = CreateSupportResponse.fromJson(body);
      if (apiResponse.status == 1) {
        return apiResponse;
      }

      throw ApiException(
        apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Failed to update support request status. Please try again.',
      );
    }

    throw _httpError(
      response.statusCode,
      apiMessage,
      'support request status',
    );
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      throw ApiException('Unexpected response from server. Please try again.');
    }
    throw ApiException('Unexpected response from server. Please try again.');
  }

  int _parseStatus(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  ApiException _httpError(int statusCode, String? apiMessage, String action) {
    switch (statusCode) {
      case 400:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Invalid request. Please check your details.',
        );
      case 401:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Unauthorized. Please check your credentials.',
        );
      case 403:
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Access forbidden. Please contact support.',
        );
      default:
        if (statusCode >= 500) {
          return ApiException(
            apiMessage?.isNotEmpty == true
                ? apiMessage!
                : 'Server error. Please try again later.',
          );
        }
        return ApiException(
          apiMessage?.isNotEmpty == true
              ? apiMessage!
              : 'Failed to fetch $action. Please try again.',
        );
    }
  }
}
