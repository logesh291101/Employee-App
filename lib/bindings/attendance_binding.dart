import 'package:employee_app/repositories/attendance_repository.dart';
import 'package:employee_app/services/attendance_service.dart';
import 'package:employee_app/viewmodels/attendance_dashboard_viewmodel.dart';
import 'package:get/get.dart';

class AttendanceBinding extends Bindings {
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
    if (!Get.isRegistered<AttendanceDashboardViewModel>()) {
      Get.lazyPut<AttendanceDashboardViewModel>(
        () => AttendanceDashboardViewModel(Get.find<AttendanceRepository>()),
        fenix: true,
      );
    }
  }
}
