import 'package:employee_app/bindings/change_password_binding.dart';
import 'package:employee_app/bindings/delete_account_binding.dart';
import 'package:employee_app/bindings/initial_binding.dart';
import 'package:employee_app/bindings/login_binding.dart';
import 'package:employee_app/bindings/forgot_password_binding.dart';
import 'package:employee_app/core/routes/app_routes.dart';
import 'package:employee_app/screens/change_password/change_password_screen.dart';
import 'package:employee_app/screens/delete_account/delete_account_screen.dart';
import 'package:employee_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:employee_app/screens/home/home_screen.dart';
import 'package:employee_app/screens/login/login_screen.dart';
import 'package:employee_app/screens/signup/sign_up_screen.dart';
import 'package:employee_app/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.deleteAccount,
      page: () => const DeleteAccountScreen(),
      binding: DeleteAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
  ];
}
