import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local/hive_service.dart';
import 'data/datasources/remote/api_client.dart';
import 'data/datasources/remote/gemini_service.dart';
import 'data/repositories/assistant_repository_impl.dart';
import 'data/repositories/market_repository_impl.dart';
import 'firebase_options.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'presentation/providers/crop_diagnosis_provider.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/market_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/voice_assistant_provider.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive init
  await HiveService.instance.init();

  runApp(const ProjectKisanApp());
}

class ProjectKisanApp extends StatelessWidget {
  const ProjectKisanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => CropDiagnosisProvider()),
        ChangeNotifierProvider(
          create: (_) => MarketProvider(
            marketRepository: MarketRepositoryImpl(
              apiClient: ApiClient.instance,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => VoiceAssistantProvider(
            assistantRepository: AssistantRepositoryImpl(
              geminiService: GeminiService.instance,
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Project Kisan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
