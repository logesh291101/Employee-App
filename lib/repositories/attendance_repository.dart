import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/attendance/attendance_action_response.dart';
import 'package:employee_app/services/attendance_service.dart';

class AttendanceRepository {
  AttendanceRepository(this._attendanceService);

  final AttendanceService _attendanceService;

  Future<AttendanceActionResponse> recordAttendanceAction({
    required String date,
    required String time,
    required String actionType,
  }) async {
    try {
      return await _attendanceService.recordAttendanceAction(
        date: date,
        time: time,
        actionType: actionType,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
