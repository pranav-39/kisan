import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/datasources/local/hive_service.dart';
import '../../data/models/weather_model.dart';
import '../../domain/entities/weather_entity.dart';

enum WeatherLoadingState {
  initial,
  loading,
  loaded,
  error,
}

class WeatherProvider extends ChangeNotifier {
  WeatherLoadingState _state = WeatherLoadingState.initial;
  WeatherEntity? _weather;
  String? _errorMessage;
  Position? _currentPosition;

  WeatherLoadingState get state => _state;
  WeatherEntity? get weather => _weather;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == WeatherLoadingState.loading;
  bool get hasData => _weather != null;
  bool get hasError => _state == WeatherLoadingState.error;

  Future<void> loadWeather({bool forceRefresh = false}) async {
    if (_state == WeatherLoadingState.loading) return;

    _state = WeatherLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = await _loadFromCache();
        if (cached != null) {
          _weather = cached;
          _state = WeatherLoadingState.loaded;
          notifyListeners();
          return;
        }
      }

      // Get current location
      await _getCurrentLocation();

      if (_currentPosition == null) {
        throw Exception('Unable to get current location');
      }

      // TODO: Replace this mock data with a call to fetch real weather data from a repository.
      // This is mock data for demonstration
      _weather = _getMockWeatherData();

      // Cache the weather data
      await _saveToCache(_weather!);

      _state = WeatherLoadingState.loaded;
    } catch (e) {
      _state = WeatherLoadingState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Use default location (Delhi) if location fails
      _currentPosition = Position(
        latitude: 28.6139,
        longitude: 77.2090,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  Future<WeatherEntity?> _loadFromCache() async {
    try {
      if (!HiveService.instance.isWeatherCacheValid()) {
        return null;
      }

      final cachedData = HiveService.instance.getCachedWeather();
      if (cachedData != null) {
        return WeatherModel.fromJson(cachedData);
      }
    } catch (e) {
      debugPrint('Error loading weather from cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(WeatherEntity weather) async {
    try {
      final model = WeatherModel.fromEntity(weather);
      await HiveService.instance.cacheWeather(model.toJson());
    } catch (e) {
      debugPrint('Error saving weather to cache: $e');
    }
  }

  WeatherEntity _getMockWeatherData() {
    final now = DateTime.now();

    return WeatherEntity(
      locationName: 'New Delhi, India',
      latitude: _currentPosition?.latitude ?? 28.6139,
      longitude: _currentPosition?.longitude ?? 77.2090,
      current: const CurrentWeather(
        temperature: 28.5,
        feelsLike: 31.2,
        humidity: 65,
        windSpeed: 12.5,
        windDirection: 'NW',
        rainfall: 0.0,
        uvIndex: 6,
        condition: 'Partly Cloudy',
        conditionIcon: 'partly_cloudy',
      ),
      forecast: List.generate(7, (index) {
        return DailyForecast(
          date: now.add(Duration(days: index)),
          tempMin: 24.0 + index,
          tempMax: 32.0 + index,
          humidity: 60 + index * 2,
          rainProbability: index < 3 ? 10.0 : 40.0,
          condition: index < 3 ? 'Sunny' : 'Partly Cloudy',
          conditionIcon: index < 3 ? 'sunny' : 'partly_cloudy',
        );
      }),
      advice: const FarmingAdvice(
        irrigation: IrrigationAdvice(
          shouldIrrigate: true,
          recommendation:
              'Soil moisture is low. Irrigate in the early morning for best results.',
          bestTime: '6:00 AM - 8:00 AM',
        ),
        spray: SprayAdvice(
          isSuitable: true,
          recommendation:
              'Weather conditions are favorable for pesticide application. Low wind and no rain expected.',
          bestWindow: '7:00 AM - 10:00 AM',
        ),
        generalTips: [
          'Good day for field preparation activities',
          'Monitor crops for pest activity',
          'Consider mulching to retain soil moisture',
        ],
        alerts: [],
      ),
      updatedAt: now,
    );
  }

  void clearCache() {
    HiveService.instance.clearWeatherCache();
    _weather = null;
    _state = WeatherLoadingState.initial;
    notifyListeners();
  }
}
