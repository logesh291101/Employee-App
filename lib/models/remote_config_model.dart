import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteConfigKeys {
  RemoteConfigKeys._();

  static const androidForceUpdate = 'android_forceUpdate';
  static const androidUpdateReason = 'android_updateReason';
  static const androidVersion = 'android_version';

  static const iosForceUpdate = 'ios_forceUpdate';
  static const iosUpdateReason = 'ios_updateReason';
  static const iosVersion = 'ios_version';

  static const liveUrl = 'live_url';
}

class RemoteConfigModel {
  const RemoteConfigModel({
    required this.androidForceUpdate,
    required this.androidUpdateReason,
    required this.androidVersion,
    required this.iosForceUpdate,
    required this.iosUpdateReason,
    required this.iosVersion,
    required this.liveUrl,
  });

  final bool androidForceUpdate;
  final String androidUpdateReason;
  final String androidVersion;

  final bool iosForceUpdate;
  final String iosUpdateReason;
  final String iosVersion;

  final String liveUrl;

  bool get forceUpdate =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? iosForceUpdate
          : androidForceUpdate;

  String get updateReason =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? iosUpdateReason
          : androidUpdateReason;

  String get version =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? iosVersion
          : androidVersion;

  factory RemoteConfigModel.fromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
    return RemoteConfigModel(
      androidForceUpdate: remoteConfig.getBool(RemoteConfigKeys.androidForceUpdate),
      androidUpdateReason:
          remoteConfig.getString(RemoteConfigKeys.androidUpdateReason),
      androidVersion: remoteConfig.getString(RemoteConfigKeys.androidVersion),
      iosForceUpdate: remoteConfig.getBool(RemoteConfigKeys.iosForceUpdate),
      iosUpdateReason: remoteConfig.getString(RemoteConfigKeys.iosUpdateReason),
      iosVersion: remoteConfig.getString(RemoteConfigKeys.iosVersion),
      liveUrl: remoteConfig.getString(RemoteConfigKeys.liveUrl),
    );
  }

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return RemoteConfigModel(
      androidForceUpdate: json[RemoteConfigKeys.androidForceUpdate] as bool? ??
          false,
      androidUpdateReason:
          json[RemoteConfigKeys.androidUpdateReason] as String? ?? '',
      androidVersion:
          json[RemoteConfigKeys.androidVersion] as String? ?? '1.0.0',
      iosForceUpdate:
          json[RemoteConfigKeys.iosForceUpdate] as bool? ?? false,
      iosUpdateReason:
          json[RemoteConfigKeys.iosUpdateReason] as String? ?? '',
      iosVersion: json[RemoteConfigKeys.iosVersion] as String? ?? '1.0.0',
      liveUrl: json[RemoteConfigKeys.liveUrl] as String? ?? '',
    );
  }

  factory RemoteConfigModel.fromSharedPreferences(SharedPreferences prefs) {
    return RemoteConfigModel(
      androidForceUpdate:
          prefs.getBool(RemoteConfigKeys.androidForceUpdate) ?? false,
      androidUpdateReason:
          prefs.getString(RemoteConfigKeys.androidUpdateReason) ?? '',
      androidVersion:
          prefs.getString(RemoteConfigKeys.androidVersion) ?? '1.0.0',
      iosForceUpdate: prefs.getBool(RemoteConfigKeys.iosForceUpdate) ?? false,
      iosUpdateReason:
          prefs.getString(RemoteConfigKeys.iosUpdateReason) ?? '',
      iosVersion: prefs.getString(RemoteConfigKeys.iosVersion) ?? '1.0.0',
      liveUrl: prefs.getString(RemoteConfigKeys.liveUrl) ?? '',
    );
  }

  factory RemoteConfigModel.defaults() {
    return const RemoteConfigModel(
      androidForceUpdate: false,
      androidUpdateReason: '',
      androidVersion: '1.0.0',
      iosForceUpdate: false,
      iosUpdateReason: '',
      iosVersion: '1.0.0',
      liveUrl: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RemoteConfigKeys.androidForceUpdate: androidForceUpdate,
      RemoteConfigKeys.androidUpdateReason: androidUpdateReason,
      RemoteConfigKeys.androidVersion: androidVersion,
      RemoteConfigKeys.iosForceUpdate: iosForceUpdate,
      RemoteConfigKeys.iosUpdateReason: iosUpdateReason,
      RemoteConfigKeys.iosVersion: iosVersion,
      RemoteConfigKeys.liveUrl: liveUrl,
    };
  }

  static Map<String, dynamic> defaultRemoteConfigValues() {
    return RemoteConfigModel.defaults().toJson();
  }
}
