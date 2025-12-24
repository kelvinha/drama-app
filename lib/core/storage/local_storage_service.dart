import 'dart:convert';
import 'package:localstorage/localstorage.dart';

/// Local Storage Service
/// Service untuk mengelola penyimpanan lokal menggunakan localstorage package

class LocalStorageService {
  static LocalStorageService? _instance;
  static bool _initialized = false;

  LocalStorageService._internal();

  static LocalStorageService get instance {
    _instance ??= LocalStorageService._internal();
    return _instance!;
  }

  /// Initialize local storage - harus dipanggil sebelum menggunakan service
  static Future<void> initialize() async {
    if (!_initialized) {
      await initLocalStorage();
      _initialized = true;
    }
  }

  /// Save string value
  void setString(String key, String value) {
    localStorage.setItem(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return localStorage.getItem(key);
  }

  /// Save object as JSON
  void setObject(String key, Map<String, dynamic> value) {
    localStorage.setItem(key, jsonEncode(value));
  }

  /// Get object from JSON
  Map<String, dynamic>? getObject(String key) {
    final value = localStorage.getItem(key);
    if (value != null) {
      return jsonDecode(value) as Map<String, dynamic>;
    }
    return null;
  }

  /// Save list as JSON
  void setList(String key, List<dynamic> value) {
    localStorage.setItem(key, jsonEncode(value));
  }

  /// Get list from JSON
  List<dynamic>? getList(String key) {
    final value = localStorage.getItem(key);
    if (value != null) {
      return jsonDecode(value) as List<dynamic>;
    }
    return null;
  }

  /// Remove item
  void remove(String key) {
    localStorage.removeItem(key);
  }

  /// Clear all data
  void clear() {
    localStorage.clear();
  }
}

/// Storage Keys
/// Konstanta untuk key penyimpanan
class StorageKeys {
  static const String cachedUsers = 'cached_users';
  static const String lastFetchTime = 'last_fetch_time';
  static const String userToken = 'user_token';
}
