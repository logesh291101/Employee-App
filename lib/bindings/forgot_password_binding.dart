import 'package:employee_app/repositories/forgot_password_repository.dart';
import 'package:employee_app/viewmodels/forgot_password_viewmodel.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordViewModel>(
      () => ForgotPasswordViewModel(Get.find<ForgotPasswordRepository>()),
    );
  }
}
