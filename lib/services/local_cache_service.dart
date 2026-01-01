import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for local data persistence
/// Uses SharedPreferences for simple key-value storage
class LocalCacheService {
  LocalCacheService._();
  
  static LocalCacheService? _instance;
  static SharedPreferences? _prefs;

  /// Get singleton instance
  static Future<LocalCacheService> getInstance() async {
    if (_instance == null) {
      _instance = LocalCacheService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// For testing - inject mock SharedPreferences
  @visibleForTesting
  static void setInstance(LocalCacheService instance, SharedPreferences prefs) {
    _instance = instance;
    _prefs = prefs;
  }

  /// Reset singleton (for testing)
  @visibleForTesting
  static void reset() {
    _instance = null;
    _prefs = null;
  }

  // ============ Generic Methods ============

  /// Save a JSON object
  Future<bool> saveJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await _prefs!.setString(key, jsonString);
    } catch (e) {
      debugPrint('LocalCacheService: Error saving JSON for key $key: $e');
      return false;
    }
  }

  /// Get a JSON object
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('LocalCacheService: Error reading JSON for key $key: $e');
      return null;
    }
  }

  /// Save a string
  Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  /// Get a string
  String? getString(String key) {
    return _prefs!.getString(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }

  // ============ App-Specific Keys ============

  /// Key for stored locale preference
  static const String keyLocale = 'app_locale';

  /// Key prefix for config cache per locale
  static String keyConfigForLocale(String localeCode) => 
      'app_config_$localeCode';

  /// Key for last used restaurant ID
  static const String keyRestaurantId = 'restaurant_id';
}

