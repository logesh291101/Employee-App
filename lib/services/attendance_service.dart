import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/attendance/attendance_action_response.dart';
import 'package:employee_app/models/attendance/work_time_history_model.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  AttendanceService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<AttendanceActionResponse> recordAttendanceAction({
    required String date,
    required String time,
    required String actionType,
  }) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final email = await SharedPrefHelper.getEmail();
    if (email.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final uri = _buildActionUri(liveUrl);
    final body = {
      'email': email,
      'date': date,
      'time': time,
      'action_type': actionType,
    };

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _parseActionResponse(response);
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

  Future<WorkTimeHistoryModel> getWorkingSummary({
    String? fromDate,
    String? toDate,
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

    final body = <String, dynamic>{'staff_id': staffIdInt};
    final trimmedFrom = fromDate?.trim();
    final trimmedTo = toDate?.trim();
    if (trimmedFrom != null && trimmedFrom.isNotEmpty) {
      body['from_date'] = trimmedFrom;
    }
    if (trimmedTo != null && trimmedTo.isNotEmpty) {
      body['to_date'] = trimmedTo;
    }

    final uri = _buildWorkingSummaryUri(liveUrl);

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _parseWorkingSummaryResponse(response);
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

  Uri _buildActionUri(String liveUrl) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse(
      '${normalized}employeeattendance/checkInCheckOut',
    );
  }

  Uri _buildWorkingSummaryUri(String liveUrl) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse(
      '${normalized}employeeattendance/working-summary',
    );
  }

  WorkTimeHistoryModel _parseWorkingSummaryResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message']?.toString();

    if (response.statusCode == 200) {
      return WorkTimeHistoryModel.fromJson(body);
    }

    throw _httpError(response.statusCode, apiMessage);
  }


  AttendanceActionResponse _parseActionResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      final model = AttendanceActionResponse.fromJson(body);
      if (model.status) {
        return model;
      }

      throw ApiException(
        model.message.isNotEmpty
            ? model.message
            : 'Something went wrong. Please try again.',
      );
    }

    throw _httpError(response.statusCode, apiMessage);
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

  ApiException _httpError(int statusCode, String? apiMessage) {
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
              : 'Something went wrong. Please try again.',
        );
    }
  }
}
