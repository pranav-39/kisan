import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherByLocation({
    required double latitude,
    required double longitude,
  });
  
  Future<WeatherEntity> getWeatherByLocationName(String locationName);
  
  Future<WeatherEntity?> getCachedWeather();
  
  Future<void> cacheWeather(WeatherEntity weather);
  
  Future<FarmingAdvice> getAIFarmingAdvice({
    required WeatherEntity weather,
    String? cropType,
  });
  
  Future<void> clearCache();
}
