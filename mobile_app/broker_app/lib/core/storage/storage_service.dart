import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StorageService(this._prefs) {
    _migrateLegacyToken();
  }

  // Migrate token from SharedPreferences to SecureStorage if it exists
  Future<void> _migrateLegacyToken() async {
    final legacyToken = _prefs.getString('auth_token');
    if (legacyToken != null) {
      await saveAuthToken(legacyToken);
      await _prefs.remove('auth_token');
    }
  }

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token).timeout(const Duration(seconds: 3));
    } catch (e) {
      try {
        await _secureStorage.deleteAll().timeout(const Duration(seconds: 2));
        await _secureStorage.write(key: 'auth_token', value: token).timeout(const Duration(seconds: 3));
      } catch (_) {}
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token').timeout(const Duration(seconds: 3));
    } catch (e) {
      try {
        await _secureStorage.deleteAll().timeout(const Duration(seconds: 2));
      } catch (_) {}
      return null;
    }
  }

  Future<void> clearAuthToken() async {
    try {
      await _secureStorage.delete(key: 'auth_token').timeout(const Duration(seconds: 3));
    } catch (e) {
      try {
        await _secureStorage.deleteAll().timeout(const Duration(seconds: 2));
      } catch (_) {}
    }
  }

  Future<bool> get isLoggedIn async => (await getAuthToken()) != null;

  // User Data
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString('user', jsonEncode(user));
  }

  Map<String, dynamic>? getUser() {
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove('user');
  }

  // Generic Methods
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
