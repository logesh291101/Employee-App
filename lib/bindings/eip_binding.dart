import 'package:employee_app/repositories/eip_repository.dart';
import 'package:employee_app/services/eip_service.dart';
import 'package:employee_app/viewmodels/eip_viewmodel.dart';
import 'package:get/get.dart';

class EIPBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EIPService>()) {
      Get.lazyPut<EIPService>(() => EIPService(), fenix: true);
    }
    if (!Get.isRegistered<EIPRepository>()) {
      Get.lazyPut<EIPRepository>(
        () => EIPRepository(Get.find<EIPService>()),
        fenix: true,
      );
    }
    Get.lazyPut<EIPViewModel>(
      () => EIPViewModel(Get.find<EIPRepository>()),
    );
  }
}
