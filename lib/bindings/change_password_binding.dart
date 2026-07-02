import 'package:employee_app/repositories/change_password_repository.dart';
import 'package:employee_app/viewmodels/change_password_viewmodel.dart';
import 'package:get/get.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordViewModel>(
      () => ChangePasswordViewModel(Get.find<ChangePasswordRepository>()),
    );
  }
}
