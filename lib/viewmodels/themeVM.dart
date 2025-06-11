import 'package:flutter/cupertino.dart';
import 'package:vi_nho/services/sharedPreference.dart';

class ThemeVM extends ChangeNotifier{
  static final ThemeVM _instance = ThemeVM._internal();
  bool _isDark = false;

  ThemeVM._internal(){
    _isDark = SharedPreference.instance.getValue<bool>('isDark') ?? false;
  }

  factory ThemeVM(){
    return _instance;
  }

  static ThemeVM get instance => _instance;
  bool get isDark => _isDark;

  void setTheme(bool value){
    SharedPreference.instance.setValue<bool>('isDark', value);
    _isDark = value;
    notifyListeners();
  }
}