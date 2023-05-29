import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base class containing a unified API for key-value pairs' storage.
/// This class provides low level methods for storing:
/// - Sensitive keys using [FlutterSecureStorage]
/// - Insensitive keys using [SharedPreferences]
class KeyValueStorageBase {
  /// Instance of shared preferences
  static SharedPreferences? _sharedPrefs;

  /// Singleton instance of KeyValueStorage Helper
  static KeyValueStorageBase? _instance;

  /// Get instance of this class
  factory KeyValueStorageBase() => _instance ?? const KeyValueStorageBase._();

  /// Private constructor
  const KeyValueStorageBase._();

  /// Initializer for shared prefs and flutter secure storage
  /// Should be called in main before runApp and
  /// after WidgetsBinding.FlutterInitialized(), to allow for synchronous tasks
  /// when possible.
  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  /// Reads the value for the key from common preferences storage
  T? getCommon<T>(String key) {
    try {
      return switch (T) {
        String => _sharedPrefs!.getString(key) as T?,
        const (List<String>) => _sharedPrefs!.getStringList(key) as T?,
        int => _sharedPrefs!.getInt(key) as T?,
        bool => _sharedPrefs!.getBool(key) as T?,
        double => _sharedPrefs!.getDouble(key) as T?,
        _ => _sharedPrefs!.get(key) as T?
      };
    } on Exception catch (ex) {
      debugPrint('$ex');
      return null;
    }
  }

  /// Sets the value for the key to common preferences storage
  Future<bool> setCommon<T>(String key, T value) {
    return switch (T) {
      String => _sharedPrefs!.setString(key, value as String),
      const (List<String>) => _sharedPrefs!.setStringList(key, value as List<String>),
      int => _sharedPrefs!.setInt(key, value as int),
      bool => _sharedPrefs!.setBool(key, value as bool),
      double => _sharedPrefs!.setDouble(key, value as double),
      _ => _sharedPrefs!.setString(key, value as String)
    };
  }

  /// Erases common preferences keys
  Future<bool> clearCommon() => _sharedPrefs!.clear();
}
