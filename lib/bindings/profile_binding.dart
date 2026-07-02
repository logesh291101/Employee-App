import 'package:employee_app/repositories/profile_repository.dart';
import 'package:employee_app/viewmodels/profile_viewmodel.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileViewModel>()) {
      Get.lazyPut<ProfileViewModel>(
        () => ProfileViewModel(Get.find<ProfileRepository>()),
        fenix: true,
      );
    }
  }
}
