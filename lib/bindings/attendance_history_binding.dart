import 'package:employee_app/repositories/attendance_repository.dart';
import 'package:employee_app/services/attendance_service.dart';
import 'package:employee_app/viewmodels/attendance_history_viewmodel.dart';
import 'package:get/get.dart';

class AttendanceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AttendanceService>()) {
      Get.lazyPut<AttendanceService>(() => AttendanceService(), fenix: true);
    }
    if (!Get.isRegistered<AttendanceRepository>()) {
      Get.lazyPut<AttendanceRepository>(
        () => AttendanceRepository(Get.find<AttendanceService>()),
        fenix: true,
      );
    }
    Get.lazyPut<AttendanceHistoryViewModel>(
      () => AttendanceHistoryViewModel(Get.find<AttendanceRepository>()),
    );
  }
}
