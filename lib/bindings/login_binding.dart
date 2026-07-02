import 'package:employee_app/repositories/login_repository.dart';
import 'package:employee_app/viewmodels/login_viewmodel.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewModel>(
      () => LoginViewModel(Get.find<LoginRepository>()),
    );
  }
}
