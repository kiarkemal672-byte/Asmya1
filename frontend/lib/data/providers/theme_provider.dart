import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  ThemeProvider() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('asmya_dark_mode') ?? true;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('asmya_dark_mode', _isDark);
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('asmya_dark_mode', _isDark);
    notifyListeners();
  }
}
