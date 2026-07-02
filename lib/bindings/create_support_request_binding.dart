import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/viewmodels/create_support_request_viewmodel.dart';
import 'package:get/get.dart';

class CreateSupportRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSupportRequestViewModel>(
      () => CreateSupportRequestViewModel(Get.find<SupportFormRepository>()),
    );
  }
}
