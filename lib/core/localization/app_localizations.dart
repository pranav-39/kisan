import 'package:flutter/material.dart';
import 'translations/en_translations.dart';
import 'translations/hi_translations.dart';
import 'translations/kn_translations.dart';
import 'translations/te_translations.dart';
import 'translations/ta_translations.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('kn', 'IN'),
    Locale('te', 'IN'),
    Locale('ta', 'IN'),
  ];
  
  static const List<LanguageOption> languageOptions = [
    LanguageOption(code: 'en', name: 'English', nativeName: 'English'),
    LanguageOption(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageOption(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    LanguageOption(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    LanguageOption(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
  ];
  
  late Map<String, String> _localizedStrings;
  
  Future<bool> load() async {
    switch (locale.languageCode) {
      case 'hi':
        _localizedStrings = hiTranslations;
        break;
      case 'kn':
        _localizedStrings = knTranslations;
        break;
      case 'te':
        _localizedStrings = teTranslations;
        break;
      case 'ta':
        _localizedStrings = taTranslations;
        break;
      case 'en':
      default:
        _localizedStrings = enTranslations;
        break;
    }
    return true;
  }
  
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
  
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get search => translate('search');
  String get settings => translate('settings');
  String get language => translate('language');
  String get darkMode => translate('dark_mode');
  String get offline => translate('offline');
  String get online => translate('online');
  String get syncNow => translate('sync_now');
  String get lastSynced => translate('last_synced');
  
  String get home => translate('home');
  String get diagnosis => translate('diagnosis');
  String get weather => translate('weather');
  String get market => translate('market');
  String get schemes => translate('schemes');
  String get assistant => translate('assistant');
  
  String get scanCrop => translate('scan_crop');
  String get takePhoto => translate('take_photo');
  String get chooseGallery => translate('choose_gallery');
  String get diagnosisHistory => translate('diagnosis_history');
  String get noDiagnosisHistory => translate('no_diagnosis_history');
  String get analyzing => translate('analyzing');
  String get diseaseDetected => translate('disease_detected');
  String get healthyPlant => translate('healthy_plant');
  String get confidence => translate('confidence');
  String get severity => translate('severity');
  String get symptoms => translate('symptoms');
  String get treatment => translate('treatment');
  String get prevention => translate('prevention');
  String get chemicalTreatment => translate('chemical_treatment');
  String get organicTreatment => translate('organic_treatment');
  String get culturalPractices => translate('cultural_practices');
  
  String get currentWeather => translate('current_weather');
  String get forecast => translate('forecast');
  String get temperature => translate('temperature');
  String get humidity => translate('humidity');
  String get wind => translate('wind');
  String get rainfall => translate('rainfall');
  String get uvIndex => translate('uv_index');
  String get farmingAdvice => translate('farming_advice');
  String get irrigationAdvice => translate('irrigation_advice');
  String get sprayAdvice => translate('spray_advice');
  
  String get marketPrices => translate('market_prices');
  String get pricePerQuintal => translate('price_per_quintal');
  String get trendUp => translate('trend_up');
  String get trendDown => translate('trend_down');
  String get trendStable => translate('trend_stable');
  String get buyRecommendation => translate('buy_recommendation');
  String get sellRecommendation => translate('sell_recommendation');
  String get holdRecommendation => translate('hold_recommendation');
  String get nearbyMandis => translate('nearby_mandis');
  
  String get governmentSchemes => translate('government_schemes');
  String get eligibility => translate('eligibility');
  String get howToApply => translate('how_to_apply');
  String get documents => translate('documents');
  String get deadline => translate('deadline');
  String get bookmark => translate('bookmark');
  
  String get voiceAssistant => translate('voice_assistant');
  String get tapToSpeak => translate('tap_to_speak');
  String get listening => translate('listening');
  String get processing => translate('processing');
  String get speakNow => translate('speak_now');
  String get voiceCommandHint => translate('voice_command_hint');
  
  String get selectCrop => translate('select_crop');
  String get rice => translate('rice');
  String get wheat => translate('wheat');
  String get cotton => translate('cotton');
  String get tomato => translate('tomato');
  String get potato => translate('potato');
  String get maize => translate('maize');
  String get soybean => translate('soybean');
  String get sugarcane => translate('sugarcane');
  String get onion => translate('onion');
  String get chilli => translate('chilli');
  
  String get onboardingTitle1 => translate('onboarding_title_1');
  String get onboardingTitle2 => translate('onboarding_title_2');
  String get onboardingTitle3 => translate('onboarding_title_3');
  String get onboardingDesc1 => translate('onboarding_desc_1');
  String get onboardingDesc2 => translate('onboarding_desc_2');
  String get onboardingDesc3 => translate('onboarding_desc_3');
  String get getStarted => translate('get_started');
  String get skip => translate('skip');
  String get next => translate('next');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'kn', 'te', 'ta'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  
  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}
