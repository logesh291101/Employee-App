import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/viewmodels/support_viewmodel.dart';
import 'package:get/get.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportViewModel>(
      () => SupportViewModel(Get.find<SupportFormRepository>()),
    );
  }
}
