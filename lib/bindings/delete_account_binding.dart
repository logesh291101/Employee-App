import 'package:employee_app/repositories/delete_account_repository.dart';
import 'package:employee_app/viewmodels/delete_account_viewmodel.dart';
import 'package:get/get.dart';

class DeleteAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteAccountViewModel>(
      () => DeleteAccountViewModel(Get.find<DeleteAccountRepository>()),
    );
  }
}
