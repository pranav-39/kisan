import '../../domain/entities/market_entity.dart';

class MarketPriceModel extends MarketPriceEntity {
  const MarketPriceModel({
    required super.id,
    required super.cropName,
    required super.cropNameLocal,
    required super.mandiName,
    required super.mandiLocation,
    required super.state,
    required super.pricePerQuintal,
    required super.previousPrice,
    required super.trend,
    required super.percentChange,
    required super.recommendation,
    required super.aiInsight,
    required super.updatedAt,
  });

  factory MarketPriceModel.fromJson(Map<String, dynamic> json) {
    return MarketPriceModel(
      id: json['id'] as String,
      cropName: json['cropName'] as String,
      cropNameLocal: json['cropNameLocal'] as String? ?? json['cropName'] as String,
      mandiName: json['mandiName'] as String,
      mandiLocation: json['mandiLocation'] as String,
      state: json['state'] as String,
      pricePerQuintal: (json['pricePerQuintal'] as num).toDouble(),
      previousPrice: (json['previousPrice'] as num).toDouble(),
      trend: _parseTrend(json['trend'] as String),
      percentChange: (json['percentChange'] as num).toDouble(),
      recommendation: _parseRecommendation(json['recommendation'] as String),
      aiInsight: json['aiInsight'] as String? ?? '',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'cropNameLocal': cropNameLocal,
      'mandiName': mandiName,
      'mandiLocation': mandiLocation,
      'state': state,
      'pricePerQuintal': pricePerQuintal,
      'previousPrice': previousPrice,
      'trend': trend.name,
      'percentChange': percentChange,
      'recommendation': recommendation.name,
      'aiInsight': aiInsight,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MarketPriceModel.fromEntity(MarketPriceEntity entity) {
    return MarketPriceModel(
      id: entity.id,
      cropName: entity.cropName,
      cropNameLocal: entity.cropNameLocal,
      mandiName: entity.mandiName,
      mandiLocation: entity.mandiLocation,
      state: entity.state,
      pricePerQuintal: entity.pricePerQuintal,
      previousPrice: entity.previousPrice,
      trend: entity.trend,
      percentChange: entity.percentChange,
      recommendation: entity.recommendation,
      aiInsight: entity.aiInsight,
      updatedAt: entity.updatedAt,
    );
  }

  static PriceTrend _parseTrend(String value) {
    switch (value.toLowerCase()) {
      case 'up':
        return PriceTrend.up;
      case 'down':
        return PriceTrend.down;
      default:
        return PriceTrend.stable;
    }
  }

  static MarketRecommendation _parseRecommendation(String value) {
    switch (value.toLowerCase()) {
      case 'buy':
        return MarketRecommendation.buy;
      case 'sell':
        return MarketRecommendation.sell;
      default:
        return MarketRecommendation.hold;
    }
  }
}

class MandiModel extends MandiEntity {
  const MandiModel({
    required super.id,
    required super.name,
    required super.address,
    required super.state,
    required super.district,
    required super.latitude,
    required super.longitude,
    required super.distanceKm,
    required super.commodities,
    required super.contactNumber,
    required super.operatingDays,
    required super.operatingHours,
  });

  factory MandiModel.fromJson(Map<String, dynamic> json) {
    return MandiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      state: json['state'] as String,
      district: json['district'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      commodities: List<String>.from(json['commodities'] ?? []),
      contactNumber: json['contactNumber'] as String? ?? '',
      operatingDays: List<String>.from(json['operatingDays'] ?? []),
      operatingHours: json['operatingHours'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'state': state,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'distanceKm': distanceKm,
      'commodities': commodities,
      'contactNumber': contactNumber,
      'operatingDays': operatingDays,
      'operatingHours': operatingHours,
    };
  }
}
