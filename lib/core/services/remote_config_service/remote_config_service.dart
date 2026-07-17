import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  SharedPreferences? _prefs;

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal();

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error initializing local preferences in RemoteConfigService: $e');
    }
  }

  String get pollinationsApiKey {
    return 'AIzaSyA8suN7qhWeBKB0tSqpC9fFOOxtvJ_1d2k';
  }

  /// Legacy getter kept for backward compatibility
  String get googleApiKey => pollinationsApiKey;

  Future<void> setPollinationsApiKey(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString('pollinations_api_key', key);
  }

  /// Legacy setter kept for backward compatibility
  Future<void> setGoogleApiKey(String key) async {
    await setPollinationsApiKey(key);
  }
}
