import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/models/profile/employee_profile_model.dart';
import 'package:employee_app/repositories/profile_repository.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  ProfileViewModel(this._profileRepository);

  final ProfileRepository _profileRepository;

  final RxBool isLoading = false.obs;
  final Rxn<EmployeeProfileData> profile = Rxn<EmployeeProfileData>();
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await _profileRepository.getProfileDetails();
      profile.value = data;
    } on ApiException catch (error) {
      profile.value = null;
      errorMessage.value = error.message;
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      profile.value = null;
      const message = 'Something went wrong. Please try again.';
      errorMessage.value = message;
      AppSnackbar.show(message, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  String formatJoiningDate(String rawDate) {
    if (rawDate.trim().isEmpty) return rawDate;

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
  }
}
