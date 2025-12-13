import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeProvider() {
    _loadSavedTheme();
  }
  
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(SharedPrefKeys.themeMode);
      
      if (savedMode != null) {
        _themeMode = _parseThemeMode(savedMode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved theme: $e');
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode != _themeMode) {
      _themeMode = mode;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPrefKeys.themeMode, mode.name);
      } catch (e) {
        debugPrint('Error saving theme preference: $e');
      }
      
      notifyListeners();
    }
  }
  
  Future<void> toggleDarkMode() async {
    await setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
  
  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
