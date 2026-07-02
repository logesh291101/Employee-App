import 'package:employee_app/models/login/login_response.dart';
import 'package:employee_app/models/remote_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSessionKeys {
  EmployeeSessionKeys._();

  static const name = 'name';
  static const email = 'email';
  static const phonenumber = 'phonenumber';
  static const role = 'role';
  static const brand = 'brand';
  static const centre = 'centre';
  static const reportManager = 'report_manager';
  static const employeeNumber = 'employee_number';
  static const staffid = 'staffid';

  /// Legacy keys kept for cleanup during logout.
  static const legacyEmNo = 'emNo';
  static const legacyPhoneNumber = 'phone_number';
}

class SharedPrefHelper {
  SharedPrefHelper._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'SharedPrefHelper is not initialized. Call init() first.',
      );
    }
    return prefs;
  }

  static Future<void> saveRemoteConfig(RemoteConfigModel model) async {
    await init();
    final prefs = _instance;

    await prefs.setBool(
      RemoteConfigKeys.androidForceUpdate,
      model.androidForceUpdate,
    );
    await prefs.setString(
      RemoteConfigKeys.androidUpdateReason,
      model.androidUpdateReason,
    );
    await prefs.setString(
      RemoteConfigKeys.androidVersion,
      model.androidVersion,
    );

    await prefs.setBool(
      RemoteConfigKeys.iosForceUpdate,
      model.iosForceUpdate,
    );
    await prefs.setString(
      RemoteConfigKeys.iosUpdateReason,
      model.iosUpdateReason,
    );
    await prefs.setString(
      RemoteConfigKeys.iosVersion,
      model.iosVersion,
    );

    await prefs.setString(RemoteConfigKeys.liveUrl, model.liveUrl);
  }

  static Future<RemoteConfigModel?> loadRemoteConfig() async {
    await init();
    final prefs = _instance;

    if (!prefs.containsKey(RemoteConfigKeys.liveUrl) &&
        !prefs.containsKey(RemoteConfigKeys.androidVersion) &&
        !prefs.containsKey(RemoteConfigKeys.iosVersion)) {
      return null;
    }

    return RemoteConfigModel.fromSharedPreferences(prefs);
  }

  static Future<RemoteConfigModel> getRemoteConfig() async {
    final cached = await loadRemoteConfig();
    return cached ?? RemoteConfigModel.defaults();
  }

  static Future<String> getLiveUrl() async {
    await init();
    return _instance.getString(RemoteConfigKeys.liveUrl) ?? '';
  }

  static Future<String> getEmNo() async {
    await init();
    final prefs = _instance;
    return prefs.getString(EmployeeSessionKeys.employeeNumber) ??
        prefs.getString(EmployeeSessionKeys.legacyEmNo) ??
        '';
  }

  /// Returns the logged-in employee display name stored after login.
  static Future<String> getEmployeeName() async {
    await init();
    return _instance.getString(EmployeeSessionKeys.name) ?? '';
  }

  static Future<String> getStaffId() async {
    await init();
    return _instance.getString(EmployeeSessionKeys.staffid) ?? '';
  }

  static Future<void> saveEmployeeDetails(LoginEmployeeData data) async {
    await init();
    final prefs = _instance;

    await prefs.setString(EmployeeSessionKeys.name, data.name);
    await prefs.setString(EmployeeSessionKeys.email, data.email);
    await prefs.setString(EmployeeSessionKeys.phonenumber, data.phonenumber);
    await prefs.setString(EmployeeSessionKeys.role, data.role);
    await prefs.setString(EmployeeSessionKeys.brand, data.brand);
    await prefs.setString(EmployeeSessionKeys.centre, data.centre);
    await prefs.setString(
      EmployeeSessionKeys.reportManager,
      data.reportManager,
    );
    await prefs.setString(
      EmployeeSessionKeys.employeeNumber,
      data.employeeNumber,
    );
    await prefs.setString(EmployeeSessionKeys.staffid, data.staffid);
  }

  static Future<void> clearEmployeeDetails() async {
    await init();
    final prefs = _instance;

    await prefs.remove(EmployeeSessionKeys.name);
    await prefs.remove(EmployeeSessionKeys.email);
    await prefs.remove(EmployeeSessionKeys.phonenumber);
    await prefs.remove(EmployeeSessionKeys.role);
    await prefs.remove(EmployeeSessionKeys.brand);
    await prefs.remove(EmployeeSessionKeys.centre);
    await prefs.remove(EmployeeSessionKeys.reportManager);
    await prefs.remove(EmployeeSessionKeys.employeeNumber);
    await prefs.remove(EmployeeSessionKeys.staffid);
    await prefs.remove(EmployeeSessionKeys.legacyEmNo);
    await prefs.remove(EmployeeSessionKeys.legacyPhoneNumber);
  }

  /// Clears all user/session data while preserving remote config (e.g. live_url).
  static Future<void> clearUserSessionData() async {
    await clearEmployeeDetails();
  }
}
