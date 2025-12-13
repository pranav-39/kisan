import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.locationName,
    required super.latitude,
    required super.longitude,
    required super.current,
    required super.forecast,
    required super.advice,
    required super.updatedAt,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      locationName: json['locationName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      current: CurrentWeatherModel.fromJson(json['current']),
      forecast: (json['forecast'] as List)
          .map((e) => DailyForecastModel.fromJson(e))
          .toList(),
      advice: FarmingAdviceModel.fromJson(json['advice']),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'current': CurrentWeatherModel.fromEntity(current).toJson(),
      'forecast': forecast
          .map((e) => DailyForecastModel.fromEntity(e).toJson())
          .toList(),
      'advice': FarmingAdviceModel.fromEntity(advice).toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WeatherModel.fromEntity(WeatherEntity entity) {
    return WeatherModel(
      locationName: entity.locationName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      current: entity.current,
      forecast: entity.forecast,
      advice: entity.advice,
      updatedAt: entity.updatedAt,
    );
  }
}

class CurrentWeatherModel extends CurrentWeather {
  const CurrentWeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.windDirection,
    required super.rainfall,
    required super.uvIndex,
    required super.condition,
    required super.conditionIcon,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      rainfall: (json['rainfall'] as num?)?.toDouble() ?? 0.0,
      uvIndex: json['uvIndex'] as int? ?? 0,
      condition: json['condition'] as String,
      conditionIcon: json['conditionIcon'] as String,
    );
  }

  factory CurrentWeatherModel.fromEntity(CurrentWeather entity) {
    return CurrentWeatherModel(
      temperature: entity.temperature,
      feelsLike: entity.feelsLike,
      humidity: entity.humidity,
      windSpeed: entity.windSpeed,
      windDirection: entity.windDirection,
      rainfall: entity.rainfall,
      uvIndex: entity.uvIndex,
      condition: entity.condition,
      conditionIcon: entity.conditionIcon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'rainfall': rainfall,
      'uvIndex': uvIndex,
      'condition': condition,
      'conditionIcon': conditionIcon,
    };
  }
}

class DailyForecastModel extends DailyForecast {
  const DailyForecastModel({
    required super.date,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.rainProbability,
    required super.condition,
    required super.conditionIcon,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: DateTime.parse(json['date'] as String),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      humidity: json['humidity'] as int,
      rainProbability: (json['rainProbability'] as num).toDouble(),
      condition: json['condition'] as String,
      conditionIcon: json['conditionIcon'] as String,
    );
  }

  factory DailyForecastModel.fromEntity(DailyForecast entity) {
    return DailyForecastModel(
      date: entity.date,
      tempMin: entity.tempMin,
      tempMax: entity.tempMax,
      humidity: entity.humidity,
      rainProbability: entity.rainProbability,
      condition: entity.condition,
      conditionIcon: entity.conditionIcon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'tempMin': tempMin,
      'tempMax': tempMax,
      'humidity': humidity,
      'rainProbability': rainProbability,
      'condition': condition,
      'conditionIcon': conditionIcon,
    };
  }
}

class FarmingAdviceModel extends FarmingAdvice {
  const FarmingAdviceModel({
    required super.irrigation,
    required super.spray,
    super.generalTips = const [],
    super.alerts = const [],
  });

  factory FarmingAdviceModel.fromJson(Map<String, dynamic> json) {
    return FarmingAdviceModel(
      irrigation: IrrigationAdviceModel.fromJson(json['irrigation']),
      spray: SprayAdviceModel.fromJson(json['spray']),
      generalTips: json['generalTips'] != null
          ? List<String>.from(json['generalTips'])
          : const [],
      alerts: json['alerts'] != null
          ? (json['alerts'] as List)
              .map((e) => WeatherAlertModel.fromJson(e))
              .toList()
          : const [],
    );
  }

  factory FarmingAdviceModel.fromEntity(FarmingAdvice entity) {
    return FarmingAdviceModel(
      irrigation: entity.irrigation,
      spray: entity.spray,
      generalTips: entity.generalTips,
      alerts: entity.alerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'irrigation': IrrigationAdviceModel.fromEntity(irrigation).toJson(),
      'spray': SprayAdviceModel.fromEntity(spray).toJson(),
      'generalTips': generalTips,
      'alerts': alerts
          .map((e) => WeatherAlertModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}

class IrrigationAdviceModel extends IrrigationAdvice {
  const IrrigationAdviceModel({
    required super.shouldIrrigate,
    required super.recommendation,
    required super.bestTime,
  });

  factory IrrigationAdviceModel.fromJson(Map<String, dynamic> json) {
    return IrrigationAdviceModel(
      shouldIrrigate: json['shouldIrrigate'] as bool,
      recommendation: json['recommendation'] as String,
      bestTime: json['bestTime'] as String,
    );
  }

  factory IrrigationAdviceModel.fromEntity(IrrigationAdvice entity) {
    return IrrigationAdviceModel(
      shouldIrrigate: entity.shouldIrrigate,
      recommendation: entity.recommendation,
      bestTime: entity.bestTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shouldIrrigate': shouldIrrigate,
      'recommendation': recommendation,
      'bestTime': bestTime,
    };
  }
}

class SprayAdviceModel extends SprayAdvice {
  const SprayAdviceModel({
    required super.isSuitable,
    required super.recommendation,
    required super.bestWindow,
  });

  factory SprayAdviceModel.fromJson(Map<String, dynamic> json) {
    return SprayAdviceModel(
      isSuitable: json['isSuitable'] as bool,
      recommendation: json['recommendation'] as String,
      bestWindow: json['bestWindow'] as String,
    );
  }

  factory SprayAdviceModel.fromEntity(SprayAdvice entity) {
    return SprayAdviceModel(
      isSuitable: entity.isSuitable,
      recommendation: entity.recommendation,
      bestWindow: entity.bestWindow,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuitable': isSuitable,
      'recommendation': recommendation,
      'bestWindow': bestWindow,
    };
  }
}

class WeatherAlertModel extends WeatherAlert {
  const WeatherAlertModel({
    required super.type,
    required super.severity,
    required super.message,
    required super.validUntil,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      type: json['type'] as String,
      severity: json['severity'] as String,
      message: json['message'] as String,
      validUntil: DateTime.parse(json['validUntil'] as String),
    );
  }

  factory WeatherAlertModel.fromEntity(WeatherAlert entity) {
    return WeatherAlertModel(
      type: entity.type,
      severity: entity.severity,
      message: entity.message,
      validUntil: entity.validUntil,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'severity': severity,
      'message': message,
      'validUntil': validUntil.toIso8601String(),
    };
  }
}
