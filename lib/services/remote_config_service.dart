import 'package:employee_app/firebase_options.dart';
import 'package:employee_app/models/remote_config_model.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  static const Duration fetchTimeout = Duration(minutes: 1);
  static const Duration developmentMinimumFetchInterval = Duration(minutes: 5);
  static const Duration productionMinimumFetchInterval = Duration(hours: 1);

  FirebaseRemoteConfig? _remoteConfig;
  RemoteConfigModel _currentConfig = RemoteConfigModel.defaults();

  RemoteConfigModel get currentConfig => _currentConfig;

  Duration get minimumFetchInterval => kDebugMode
      ? developmentMinimumFetchInterval
      : productionMinimumFetchInterval;

  Future<void> initialize() async {
    await SharedPrefHelper.init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );

    await _remoteConfig!.setDefaults(RemoteConfigModel.defaultRemoteConfigValues());

    _currentConfig = await SharedPrefHelper.getRemoteConfig();
  }

  Future<RemoteConfigModel> fetchAndActivate() async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) {
      return _loadFallbackConfig();
    }

    try {
      await remoteConfig.fetchAndActivate();
      final model = RemoteConfigModel.fromRemoteConfig(remoteConfig);
      await SharedPrefHelper.saveRemoteConfig(model);
      _currentConfig = model;
      return model;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Remote Config fetch failed: $error');
        debugPrint('$stackTrace');
      }
      return _loadFallbackConfig();
    }
  }

  Future<RemoteConfigModel> _loadFallbackConfig() async {
    final cached = await SharedPrefHelper.loadRemoteConfig();
    _currentConfig = cached ?? RemoteConfigModel.defaults();
    return _currentConfig;
  }
}
