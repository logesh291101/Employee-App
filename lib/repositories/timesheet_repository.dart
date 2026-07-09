import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/timesheet/timesheet_history_model.dart';
import 'package:employee_app/services/timesheet_service.dart';

class TimesheetRepository {
  TimesheetRepository(this._timesheetService);

  final TimesheetService _timesheetService;

  Future<TimeSheetHistoryModel> getTimesheetHistory({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      return await _timesheetService.getTimesheetHistory(
        fromDate: fromDate,
        toDate: toDate,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<TimeSheetHistoryModel> storeTimesheet({
    required String taskDate,
    required List<Map<String, dynamic>> timesheetEntries,
  }) async {
    try {
      return await _timesheetService.storeTimesheet(
        taskDate: taskDate,
        timesheetEntries: timesheetEntries,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
