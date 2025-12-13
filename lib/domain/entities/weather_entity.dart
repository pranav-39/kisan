import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String locationName;
  final double latitude;
  final double longitude;
  final CurrentWeather current;
  final List<DailyForecast> forecast;
  final FarmingAdvice advice;
  final DateTime updatedAt;

  const WeatherEntity({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.current,
    required this.forecast,
    required this.advice,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        locationName,
        latitude,
        longitude,
        current,
        forecast,
        advice,
        updatedAt,
      ];
}

class CurrentWeather extends Equatable {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final double rainfall;
  final int uvIndex;
  final String condition;
  final String conditionIcon;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.rainfall,
    required this.uvIndex,
    required this.condition,
    required this.conditionIcon,
  });

  @override
  List<Object?> get props => [
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        windDirection,
        rainfall,
        uvIndex,
        condition,
        conditionIcon,
      ];
}

class DailyForecast extends Equatable {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double rainProbability;
  final String condition;
  final String conditionIcon;

  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.rainProbability,
    required this.condition,
    required this.conditionIcon,
  });

  @override
  List<Object?> get props => [
        date,
        tempMin,
        tempMax,
        humidity,
        rainProbability,
        condition,
        conditionIcon,
      ];
}

class FarmingAdvice extends Equatable {
  final IrrigationAdvice irrigation;
  final SprayAdvice spray;
  final List<String> generalTips;
  final List<WeatherAlert> alerts;

  const FarmingAdvice({
    required this.irrigation,
    required this.spray,
    this.generalTips = const [],
    this.alerts = const [],
  });

  @override
  List<Object?> get props => [irrigation, spray, generalTips, alerts];
}

class IrrigationAdvice extends Equatable {
  final bool shouldIrrigate;
  final String recommendation;
  final String bestTime;

  const IrrigationAdvice({
    required this.shouldIrrigate,
    required this.recommendation,
    required this.bestTime,
  });

  @override
  List<Object?> get props => [shouldIrrigate, recommendation, bestTime];
}

class SprayAdvice extends Equatable {
  final bool isSuitable;
  final String recommendation;
  final String bestWindow;

  const SprayAdvice({
    required this.isSuitable,
    required this.recommendation,
    required this.bestWindow,
  });

  @override
  List<Object?> get props => [isSuitable, recommendation, bestWindow];
}

class WeatherAlert extends Equatable {
  final String type;
  final String severity;
  final String message;
  final DateTime validUntil;

  const WeatherAlert({
    required this.type,
    required this.severity,
    required this.message,
    required this.validUntil,
  });

  @override
  List<Object?> get props => [type, severity, message, validUntil];
}
