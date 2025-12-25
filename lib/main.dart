import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/hive_service.dart';
import 'data/datasources/remote/agmarknet_api_client.dart';
import 'data/datasources/remote/gemini_service.dart';
import 'data/repositories/assistant_repository_impl.dart';
import 'data/repositories/market_repository_impl.dart';
import 'domain/repositories/assistant_repository.dart';
import 'domain/repositories/market_repository.dart';
import 'firebase_options.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'presentation/providers/crop_diagnosis_provider.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/market_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/voice_assistant_provider.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  await HiveService.instance.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Instantiate dependencies
  final dio = Dio();
  final agmarknetApiClient = AgmarknetApiClient(dio);
  final geminiService = GeminiService.instance;

  final marketRepository = MarketRepositoryImpl(agmarknetApiClient);
  final assistantRepository = AssistantRepositoryImpl(geminiService);

  runApp(ProjectKisanApp(
    marketRepository: marketRepository,
    assistantRepository: assistantRepository,
  ));
}

class ProjectKisanApp extends StatelessWidget {
  final MarketRepository marketRepository;
  final AssistantRepository assistantRepository;

  const ProjectKisanApp({
    super.key,
    required this.marketRepository,
    required this.assistantRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              VoiceAssistantProvider(assistantRepository: assistantRepository),
        ),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(
          create: (_) => MarketProvider(marketRepository),
        ),
        ChangeNotifierProvider(create: (_) => CropDiagnosisProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageProvider.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
