import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/profile/employee_profile_model.dart';
import 'package:employee_app/services/profile_service.dart';

class ProfileRepository {
  ProfileRepository(this._profileService);

  final ProfileService _profileService;

  Future<EmployeeProfileData> getProfileDetails() async {
    try {
      final response = await _profileService.getProfileDetails();
      return response.data;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
