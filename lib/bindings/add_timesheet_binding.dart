import 'package:employee_app/repositories/timesheet_repository.dart';
import 'package:employee_app/services/timesheet_service.dart';
import 'package:employee_app/viewmodels/add_timesheet_viewmodel.dart';
import 'package:get/get.dart';

class AddTimesheetBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<TimesheetService>()) {
      Get.lazyPut<TimesheetService>(() => TimesheetService(), fenix: true);
    }
    if (!Get.isRegistered<TimesheetRepository>()) {
      Get.lazyPut<TimesheetRepository>(
        () => TimesheetRepository(Get.find<TimesheetService>()),
        fenix: true,
      );
    }
    Get.lazyPut<AddTimesheetViewModel>(
      () => AddTimesheetViewModel(Get.find<TimesheetRepository>()),
    );
  }
}
