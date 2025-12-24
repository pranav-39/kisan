class AppConstants {
  AppConstants._();
  
  static const String appName = 'Project Kisan';
  static const String appVersion = '1.0.0';
  
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration syncInterval = Duration(minutes: 15);
  
  static const int maxDiagnosisHistory = 50;
  static const int maxVoiceContextTurns = 10;
  static const int maxOfflineQueueSize = 100;
  
  static const double minTouchTargetSize = 48.0;
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  
  static const List<String> supportedCrops = [
    'rice',
    'wheat',
    'cotton',
    'tomato',
    'potato',
    'maize',
    'soybean',
    'sugarcane',
    'onion',
    'chilli',
  ];
}

class ApiEndpoints {
  ApiEndpoints._();
  
  static const String baseUrl = 'https://us-central1-your-project-id.cloudfunctions.net';
  
  static const String diagnoseDisease = '/diagnoseDisease';
  static const String getWeather = '/getWeather';
  static const String getMarketPrices = '/getMarketPrices';
  static const String chatWithAssistant = '/chatWithAssistant';
  static const String getSchemes = '/getSchemes';
  static const String syncData = '/syncData';
}

class HiveBoxNames {
  HiveBoxNames._();
  
  static const String settings = 'settings';
  static const String diagnosisHistory = 'diagnosis_history';
  static const String weatherCache = 'weather_cache';
  static const String marketCache = 'market_cache';
  static const String offlineQueue = 'offline_queue';
  static const String userFields = 'user_fields';
  static const String schemes = 'schemes';
}

class SharedPrefKeys {
  SharedPrefKeys._();
  
  static const String languageCode = 'language_code';
  static const String themeMode = 'theme_mode';
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastSyncTime = 'last_sync_time';
  static const String userId = 'user_id';
}
