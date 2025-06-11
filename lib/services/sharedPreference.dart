import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  static final SharedPreference _instance = SharedPreference._internal();
  late SharedPreferences _preferences;
  SharedPreference._internal();

  static SharedPreference get instance => _instance;

  Future<void> init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> printAllPrefs() async {
    final allKeys = _preferences.getKeys();

    for (var key in allKeys) {
      final value = _preferences.get(key);
    }
  }

  bool checkKey(String key){
    return _preferences.containsKey(key);
  }

  T? getValue<T>(String key){
    if(T == String) return _preferences.getString(key) as T?;
    if(T == bool) return _preferences.getBool(key) as T?;
    if(T == int) return _preferences.getInt(key) as T?;
    throw Exception("Không tìm thấy kiểu tướng ứng GET (String / bool)");
  }

  void setValue<T>(String key, T value) async{
    if(value is String) {
      _preferences.setString(key, value as String);
    }
    else if(value is bool) {
      _preferences.setBool(key, value as bool);
    }
    else if(value is int) {
      _preferences.setInt(key, value as int);
    }
    else{
      throw Exception("Không tìm thấy kiểu tướng ứng SET (String / bool / int)");
    }
  }

  Future<bool> removeKey(String key){
    return _preferences.remove(key);
  }

  Future<bool> clearSharePre(){
    return _preferences.clear();
  }

}