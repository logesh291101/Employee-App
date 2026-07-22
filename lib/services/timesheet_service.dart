import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/timesheet/timesheet_history_model.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class TimesheetService {
  TimesheetService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 60);

  Future<TimeSheetHistoryModel> storeTimesheet({
    required String taskDate,
    required List<Map<String, dynamic>> timesheetEntries,
  }) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final employeeNumber = await SharedPrefHelper.getEmployeeNumber();
    if (employeeNumber.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final uri = _buildStoreUri(liveUrl);
    final body = {
      'staff_id': employeeNumber,
      'task_date': taskDate,
      'timesheet': timesheetEntries,
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

      return _parseStoreResponse(response);
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

  Future<TimeSheetHistoryModel> getTimesheetHistory({
    required String fromDate,
    required String toDate,
  }) async {
    final liveUrl = await SharedPrefHelper.getLiveUrl();
    if (liveUrl.trim().isEmpty) {
      throw ApiException(
        'Server URL is not configured. Please restart the app and try again.',
      );
    }

    final employeeNumber = await SharedPrefHelper.getEmployeeNumber();
    if (employeeNumber.trim().isEmpty) {
      throw ApiException(
        'Employee profile is incomplete. Please log in again.',
      );
    }

    final uri = _buildUri(liveUrl).replace(
      queryParameters: {
        'staff_id': employeeNumber,
        'from_date': fromDate,
        'to_date': toDate,
      },
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      return _parseResponse(response);
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

  Uri _buildUri(String liveUrl) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse('${normalized}timesheet');
  }

  Uri _buildStoreUri(String liveUrl) {
    final normalized = liveUrl.trim().endsWith('/')
        ? liveUrl.trim()
        : '${liveUrl.trim()}/';
    return Uri.parse('${normalized}timesheet/store');
  }

  TimeSheetHistoryModel _parseStoreResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      final model = TimeSheetHistoryModel.fromJson(body);
      if (model.status) {
        return model;
      }

      throw ApiException(
        model.message.isNotEmpty
            ? model.message
            : 'Failed to submit timesheet. Please try again.',
      );
    }

    throw _httpError(
      response.statusCode,
      apiMessage,
      'Failed to submit timesheet. Please try again.',
    );
  }

  TimeSheetHistoryModel _parseResponse(http.Response response) {
    final body = _decodeBody(response);
    final apiMessage = body['message'] as String?;

    if (response.statusCode == 200) {
      return TimeSheetHistoryModel.fromJson(body);
    }

    throw _httpError(
      response.statusCode,
      apiMessage,
      'Failed to fetch timesheet history. Please try again.',
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

  ApiException _httpError(
    int statusCode,
    String? apiMessage, [
    String fallback = 'Something went wrong. Please try again.',
  ]) {
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
          apiMessage?.isNotEmpty == true ? apiMessage! : fallback,
        );
    }
  }
}
