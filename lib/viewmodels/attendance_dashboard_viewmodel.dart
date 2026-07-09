import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/models/attendance/attendance_action_response.dart';
import 'package:employee_app/models/attendance/attendance_today_model.dart';
import 'package:employee_app/repositories/attendance_repository.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum AttendanceActionType {
  none,
  checkIn,
  checkOut,
  startBreak,
  endBreak,
}

class AttendanceDashboardViewModel extends GetxController {
  AttendanceDashboardViewModel(this._attendanceRepository);

  final AttendanceRepository _attendanceRepository;

  final Rx<AttendanceActionType> loadingAction = AttendanceActionType.none.obs;
  final RxString checkInTime = ''.obs;
  final RxString checkOutTime = ''.obs;
  final RxString totalWorkHours = ''.obs;
  final RxList<BreakRecord> breaks = <BreakRecord>[].obs;

  bool get isActionLoading => loadingAction.value != AttendanceActionType.none;

  static String formatApiDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year.toString().padLeft(4, '0')}';
  }

  static String formatApiTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  bool isLoading(AttendanceActionType action) =>
      loadingAction.value == action;

  Future<void> checkIn() => _performAction(AttendanceActionType.checkIn);

  Future<void> checkOut() => _performAction(AttendanceActionType.checkOut);

  Future<void> startBreak() => _performAction(AttendanceActionType.startBreak);

  Future<void> endBreak() => _performAction(AttendanceActionType.endBreak);

  String _actionTypeParam(AttendanceActionType action) {
    switch (action) {
      case AttendanceActionType.checkIn:
        return 'CheckIn';
      case AttendanceActionType.checkOut:
        return 'CheckOut';
      case AttendanceActionType.startBreak:
        return 'StartBreak';
      case AttendanceActionType.endBreak:
        return 'EndBreak';
      case AttendanceActionType.none:
        return '';
    }
  }

  void _applyActionResponse(
    AttendanceActionResponse response,
    AttendanceActionType action,
  ) {
    switch (action) {
      case AttendanceActionType.checkIn:
        if (response.checkInTime.isNotEmpty) {
          checkInTime.value = response.checkInTime;
        }
        break;
      case AttendanceActionType.checkOut:
        if (response.checkInTime.isNotEmpty) {
          checkInTime.value = response.checkInTime;
        }
        if (response.checkOutTime.isNotEmpty) {
          checkOutTime.value = response.checkOutTime;
        }
        if (response.workingTime.isNotEmpty) {
          totalWorkHours.value = response.workingTime;
        }
        break;
      case AttendanceActionType.startBreak:
        breaks.add(
          BreakRecord(
            startTime: response.breakStartTime,
          ),
        );
        break;
      case AttendanceActionType.endBreak:
        _applyEndBreakResponse(response);
        break;
      case AttendanceActionType.none:
        break;
    }
  }

  void _applyEndBreakResponse(AttendanceActionResponse response) {
    final openBreakIndex = breaks.lastIndexWhere(
      (record) => record.endTime.isEmpty && record.duration.isEmpty,
    );

    final updatedRecord = BreakRecord(
      startTime: response.breakStartTime.isNotEmpty
          ? response.breakStartTime
          : (openBreakIndex >= 0 ? breaks[openBreakIndex].startTime : ''),
      endTime: response.breakEndTime,
      duration: response.breakTime,
    );

    if (openBreakIndex >= 0) {
      breaks[openBreakIndex] = updatedRecord;
    } else if (updatedRecord.startTime.isNotEmpty ||
        updatedRecord.endTime.isNotEmpty ||
        updatedRecord.duration.isNotEmpty) {
      breaks.add(updatedRecord);
    }
  }

  Future<void> _performAction(AttendanceActionType action) async {
    if (isActionLoading) return;

    HapticFeedback.mediumImpact();
    loadingAction.value = action;

    try {
      final now = DateTime.now();
      final response = await _attendanceRepository.recordAttendanceAction(
        date: formatApiDate(now),
        time: formatApiTime(now),
        actionType: _actionTypeParam(action),
      );

      _applyActionResponse(response, action);
      AppSnackbar.show(response.message);
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      loadingAction.value = AttendanceActionType.none;
    }
  }
}
