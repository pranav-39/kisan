# Project Kisan

**Agentic AI-Powered Farming Intelligence Platform**

A voice-first, AI-native, offline-resilient mobile application that acts as a personal farming co-pilot for Indian farmers. Built with Flutter and powered by Google's AI stack (Gemini, Firebase, Vertex AI).

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PROJECT KISAN ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        PRESENTATION LAYER                            │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │   │
│  │  │   Screens   │  │   Widgets   │  │  Providers  │  │   Theme    │  │   │
│  │  │  - Home     │  │  - Voice    │  │  - Weather  │  │  - Colors  │  │   │
│  │  │  - Diagnosis│  │    Button   │  │  - Market   │  │  - Fonts   │  │   │
│  │  │  - Weather  │  │  - Cards    │  │  - Diagnosis│  │  - Styles  │  │   │
│  │  │  - Market   │  │  - Banners  │  │  - Language │  │            │  │   │
│  │  │  - Settings │  │             │  │  - Theme    │  │            │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     │                                       │
│                                     ▼                                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                          DOMAIN LAYER                                │   │
│  │  ┌─────────────────────────┐  ┌─────────────────────────────────┐   │   │
│  │  │        Entities         │  │         Repositories            │   │   │
│  │  │  - DiagnosisEntity      │  │  - DiagnosisRepository (abs)    │   │   │
│  │  │  - WeatherEntity        │  │  - WeatherRepository (abs)      │   │   │
│  │  │  - MarketPriceEntity    │  │  - MarketRepository (abs)       │   │   │
│  │  │  - ChatMessageEntity    │  │  - AssistantRepository (abs)    │   │   │
│  │  └─────────────────────────┘  └─────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     │                                       │
│                                     ▼                                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                           DATA LAYER                                 │   │
│  │  ┌─────────────┐  ┌─────────────────────┐  ┌─────────────────────┐  │   │
│  │  │   Models    │  │   Local DataSource  │  │  Remote DataSource  │  │   │
│  │  │  - Diagnosis│  │  - HiveService      │  │  - ApiClient        │  │   │
│  │  │  - Weather  │  │  - SharedPrefs      │  │  - GeminiService    │  │   │
│  │  │  - Market   │  │  - SQLite           │  │  - Firebase         │  │   │
│  │  └─────────────┘  └─────────────────────┘  └─────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     │                                       │
│                                     ▼                                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                           CORE LAYER                                 │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────┐  │   │
│  │  │Constants │  │  Theme   │  │  Utils   │  │  Errors  │  │  i18n │  │   │
│  │  │ - Colors │  │ - Light  │  │ - Logger │  │ -Failures│  │ - EN  │  │   │
│  │  │ - API    │  │ - Dark   │  │ - Image  │  │ -Except. │  │ - HI  │  │   │
│  │  │ - Hive   │  │ - Text   │  │ - Date   │  │          │  │ - KN  │  │   │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │ - TE  │  │   │
│  │                                                          │ - TA  │  │   │
│  │                                                          └───────┘  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          BACKEND SERVICES                                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │ Firebase Cloud  │  │   Gemini API    │  │      External APIs          │ │
│  │   Functions     │  │  - Text Gen     │  │  - Weather API              │ │
│  │  - Auth         │  │  - Vision       │  │  - Agmarknet (Mandi Prices) │ │
│  │  - Firestore    │  │  - Chat         │  │  - Maps API                 │ │
│  │  - Storage      │  │  - Multimodal   │  │  - Speech APIs              │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
project_kisan/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── core/                        # Core utilities and constants
│   │   ├── constants/
│   │   │   ├── app_constants.dart   # App-wide constants
│   │   │   └── app_colors.dart      # Color palette
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Light/Dark themes
│   │   ├── localization/            # i18n support
│   │   │   ├── app_localizations.dart
│   │   │   └── translations/        # EN, HI, KN, TE, TA
│   │   ├── utils/                   # Helper utilities
│   │   │   ├── connectivity_helper.dart
│   │   │   ├── date_formatter.dart
│   │   │   ├── image_helper.dart
│   │   │   ├── logger.dart
│   │   │   └── validators.dart
│   │   └── errors/                  # Error handling
│   │       ├── failures.dart
│   │       └── exceptions.dart
│   │
│   ├── domain/                      # Business logic layer
│   │   ├── entities/                # Core data structures
│   │   │   ├── diagnosis_entity.dart
│   │   │   ├── weather_entity.dart
│   │   │   ├── market_entity.dart
│   │   │   └── chat_message_entity.dart
│   │   └── repositories/            # Abstract repositories
│   │       ├── diagnosis_repository.dart
│   │       ├── weather_repository.dart
│   │       ├── market_repository.dart
│   │       └── assistant_repository.dart
│   │
│   ├── data/                        # Data layer
│   │   ├── models/                  # Data models with JSON
│   │   │   ├── diagnosis_model.dart
│   │   │   ├── weather_model.dart
│   │   │   └── market_model.dart
│   │   └── datasources/
│   │       ├── local/
│   │       │   └── hive_service.dart
│   │       └── remote/
│   │           ├── api_client.dart
│   │           └── gemini_service.dart
│   │
│   └── presentation/                # UI layer
│       ├── providers/               # State management
│       │   ├── language_provider.dart
│       │   ├── theme_provider.dart
│       │   ├── connectivity_provider.dart
│       │   ├── voice_assistant_provider.dart
│       │   ├── weather_provider.dart
│       │   ├── market_provider.dart
│       │   └── crop_diagnosis_provider.dart
│       ├── screens/                 # App screens
│       │   ├── splash/
│       │   ├── onboarding/
│       │   ├── home/
│       │   ├── diagnosis/
│       │   ├── weather/
│       │   ├── market/
│       │   ├── assistant/
│       │   └── settings/
│       └── widgets/                 # Reusable widgets
│           ├── connectivity_banner.dart
│           └── floating_voice_button.dart
│
├── functions/                       # Firebase Cloud Functions
│   ├── index.js                     # Function definitions
│   └── package.json
│
├── assets/                          # Static assets
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── data/
│
├── pubspec.yaml                     # Flutter dependencies
├── analysis_options.yaml            # Linting rules
└── README.md                        # This file
```

## Features

### MVP Features (Implemented)

- **Gemini AI Voice Assistant**
  - Text and voice interaction
  - Multi-turn context support
  - Suggested commands
  - Speech-to-text and TTS abstractions

- **Crop Disease Detection**
  - Camera/gallery image capture
  - Gemini Vision API integration (stub)
  - Detailed diagnosis results with treatment plans
  - Diagnosis history with offline storage

- **Weather Intelligence**
  - GPS-based location detection
  - Current conditions and 7-day forecast
  - AI-generated farming advice
  - Irrigation and spray timing recommendations

- **Market Prices**
  - Mandi prices with trend indicators
  - AI-powered buy/sell/hold recommendations
  - Crop and state filtering
  - Offline caching

- **Multilingual Support**
  - English, Hindi, Kannada, Telugu, Tamil
  - Runtime language switching
  - Fully localized UI

- **Offline-First Architecture**
  - Hive local storage
  - Connectivity monitoring
  - Sync queue for pending operations

### Design Highlights

- High-contrast sunlight-readable UI
- Large touch targets (min 48dp)
- Icon-heavy minimal text interface
- Dark mode support
- Farmer-friendly guided onboarding

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode
- Firebase CLI
- Google Cloud account (for Gemini API)

### Android Setup

1. Clone the repository
2. Run `flutter pub get`
3. Create `android/app/google-services.json` from Firebase Console
4. Configure AndroidManifest.xml permissions (camera, location, microphone)
5. Run `flutter run`

### iOS Setup

1. Run `flutter pub get`
2. Navigate to `ios/` and run `pod install`
3. Add `GoogleService-Info.plist` from Firebase Console
4. Configure Info.plist with camera, location, microphone permissions
5. Run `flutter run`

### Firebase Setup

1. Create a Firebase project
2. Enable Firestore, Authentication, Cloud Functions
3. Deploy Cloud Functions: `cd functions && npm install && firebase deploy --only functions`
4. Set Gemini API key: `firebase functions:config:set gemini.api_key="YOUR_KEY"`

### Environment Variables

Create `.env` file (not committed to git):

```env
GEMINI_API_KEY=your_gemini_api_key
FIREBASE_PROJECT_ID=your_project_id
WEATHER_API_KEY=your_weather_api_key
```

## TODOs for Production

### Platform-Specific Setup Required

- [ ] Configure Firebase for Android (`google-services.json`)
- [ ] Configure Firebase for iOS (`GoogleService-Info.plist`)
- [ ] Set up App Signing for Play Store
- [ ] Configure Apple Developer certificates for App Store
- [ ] Add actual Gemini API key to Cloud Functions
- [ ] Integrate real weather API (OpenWeatherMap/WeatherAPI)
- [ ] Connect to Agmarknet API for live mandi prices

### Feature Enhancements

- [ ] Implement actual Speech-to-Text integration
- [ ] Add Text-to-Speech for voice responses
- [ ] GPS field mapping with polygon drawing
- [ ] Government schemes database with eligibility checker
- [ ] Push notifications via Firebase Cloud Messaging
- [ ] Farmer community discussion board
- [ ] Crop calendar with activity reminders
- [ ] IoT sensor data integration

### Testing

- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Integration tests for complete flows
- [ ] Performance testing for offline scenarios

## Future Roadmap

### Phase 2: Enhanced AI Features
- Predictive pest and disease alerts
- Crop yield estimation
- Personalized farming recommendations
- Weather-based spray scheduling

### Phase 3: Community & Marketplace
- Farmer-to-farmer marketplace
- Expert consultation booking
- Kisan Voice Card (voice-based updates)
- Regional farming groups

### Phase 4: IoT & Precision Farming
- Soil sensor integration
- Automated irrigation triggers
- Drone imagery analysis
- Satellite-based crop monitoring

## Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter (Dart) |
| State Management | Provider |
| Local Storage | Hive, SharedPreferences |
| Backend | Firebase Cloud Functions |
| Database | Cloud Firestore |
| AI/ML | Google Gemini API |
| Authentication | Firebase Auth (optional) |
| Maps | Google Maps SDK |
| Voice | Google Speech-to-Text, Flutter TTS |

## License

This project is developed for the Google AI Hackathon and is intended for educational and demonstration purposes.

## Contributors

Project Kisan Development Team

---

*Built with love for Indian farmers*
