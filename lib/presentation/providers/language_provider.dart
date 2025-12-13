import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  
  LanguageOption get currentLanguageOption {
    return AppLocalizations.languageOptions.firstWhere(
      (option) => option.code == _currentLocale.languageCode,
      orElse: () => AppLocalizations.languageOptions.first,
    );
  }
  
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(SharedPrefKeys.languageCode);
      
      if (savedCode != null) {
        final locale = _getLocaleFromCode(savedCode);
        if (locale != null) {
          _currentLocale = locale;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    final locale = _getLocaleFromCode(languageCode);
    if (locale != null && locale != _currentLocale) {
      _currentLocale = locale;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(SharedPrefKeys.languageCode, languageCode);
      } catch (e) {
        debugPrint('Error saving language preference: $e');
      }
      
      notifyListeners();
    }
  }
  
  Locale? _getLocaleFromCode(String code) {
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == code) {
        return locale;
      }
    }
    return null;
  }
  
  List<LanguageOption> get availableLanguages => AppLocalizations.languageOptions;
  
  bool isCurrentLanguage(String code) => _currentLocale.languageCode == code;
}
