import 'package:employee_app/models/remote_config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
