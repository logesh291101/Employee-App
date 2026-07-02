import 'package:employee_app/repositories/change_password_repository.dart';
import 'package:employee_app/repositories/delete_account_repository.dart';
import 'package:employee_app/repositories/forgot_password_repository.dart';
import 'package:employee_app/repositories/login_repository.dart';
import 'package:employee_app/repositories/profile_repository.dart';
import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/services/change_password_service.dart';
import 'package:employee_app/services/delete_account_service.dart';
import 'package:employee_app/services/forgot_password_service.dart';
import 'package:employee_app/services/login_service.dart';
import 'package:employee_app/services/profile_service.dart';
import 'package:employee_app/services/support_form_service.dart';
import 'package:employee_app/viewmodels/profile_viewmodel.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginService>(() => LoginService(), fenix: true);
    Get.lazyPut<LoginRepository>(
      () => LoginRepository(Get.find<LoginService>()),
      fenix: true,
    );
    Get.lazyPut<ForgotPasswordService>(
      () => ForgotPasswordService(),
      fenix: true,
    );
    Get.lazyPut<ForgotPasswordRepository>(
      () => ForgotPasswordRepository(Get.find<ForgotPasswordService>()),
      fenix: true,
    );
    Get.lazyPut<DeleteAccountService>(
      () => DeleteAccountService(),
      fenix: true,
    );
    Get.lazyPut<DeleteAccountRepository>(
      () => DeleteAccountRepository(Get.find<DeleteAccountService>()),
      fenix: true,
    );
    Get.lazyPut<ChangePasswordService>(
      () => ChangePasswordService(),
      fenix: true,
    );
    Get.lazyPut<ChangePasswordRepository>(
      () => ChangePasswordRepository(Get.find<ChangePasswordService>()),
      fenix: true,
    );
    Get.lazyPut<ProfileService>(() => ProfileService(), fenix: true);
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(Get.find<ProfileService>()),
      fenix: true,
    );
    Get.lazyPut<SupportFormService>(
      () => SupportFormService(),
      fenix: true,
    );
    Get.lazyPut<SupportFormRepository>(
      () => SupportFormRepository(Get.find<SupportFormService>()),
      fenix: true,
    );
    Get.lazyPut<ProfileViewModel>(
      () => ProfileViewModel(Get.find<ProfileRepository>()),
      fenix: true,
    );
  }
}
