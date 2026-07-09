import 'package:employee_app/repositories/hierarchy_repository.dart';
import 'package:employee_app/services/hierarchy_service.dart';
import 'package:employee_app/viewmodels/hierarchy_viewmodel.dart';
import 'package:get/get.dart';

class HierarchyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HierarchyService>()) {
      Get.lazyPut<HierarchyService>(() => HierarchyService(), fenix: true);
    }
    if (!Get.isRegistered<HierarchyRepository>()) {
      Get.lazyPut<HierarchyRepository>(
        () => HierarchyRepository(Get.find<HierarchyService>()),
        fenix: true,
      );
    }
    Get.lazyPut<HierarchyViewModel>(
      () => HierarchyViewModel(Get.find<HierarchyRepository>()),
    );
  }
}
