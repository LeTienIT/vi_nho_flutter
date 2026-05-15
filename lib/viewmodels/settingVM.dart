import 'package:flutter/foundation.dart';

import '../services/database.dart';

class SettingVM extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  /// cache local
  final Map<String, String?> _cache = {};

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    final data = await _db.getAllSettings();
    _cache.clear();
    _cache.addAll(data);

    _initialized = true;
    notifyListeners();
  }

  Future<String?> get(String key, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.containsKey(key)) {
      return _cache[key];
    }

    final value = await _db.getSetting(key);
    _cache[key] = value;
    return value;
  }

  String? getSync(String key) {
    return _cache[key];
  }

  Future<void> set(String key, String? value) async {
    await _db.setSetting(key, value);
    _cache[key] = value;
    notifyListeners();
  }

  Future<void> remove(String key) async {
    await _db.removeSetting(key);
    _cache.remove(key);
    notifyListeners();
  }

  Future<void> clear() async {
    await _db.clearSettings();
    _cache.clear();
    notifyListeners();
  }

  Future<bool> has(String key) async {
    if (_cache.containsKey(key)) return true;
    return await _db.hasSetting(key);
  }

  Future<int?> getInt(String key) async {
    final v = await get(key);
    return v != null ? int.tryParse(v) : null;
  }

  Future<void> setInt(String key, int value) async {
    await set(key, value.toString());
  }

  Future<bool?> getBool(String key) async {
    final v = await get(key);
    if (v == null) return null;
    return v == 'true';
  }

  Future<void> setBool(String key, bool value) async {
    await set(key, value.toString());
  }

  Future<double?> getDouble(String key) async {
    final v = await get(key);
    return v != null ? double.tryParse(v) : null;
  }

  Future<void> setDouble(String key, double value) async {
    await set(key, value.toString());
  }
}