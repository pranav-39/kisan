import 'package:equatable/equatable.dart';

enum PriceTrend { up, down, stable }
enum MarketRecommendation { buy, sell, hold }

class MarketPriceEntity extends Equatable {
  final String id;
  final String cropName;
  final String cropNameLocal;
  final String mandiName;
  final String mandiLocation;
  final String state;
  final double pricePerQuintal;
  final double previousPrice;
  final PriceTrend trend;
  final double percentChange;
  final MarketRecommendation recommendation;
  final String aiInsight;
  final DateTime updatedAt;

  const MarketPriceEntity({
    required this.id,
    required this.cropName,
    required this.cropNameLocal,
    required this.mandiName,
    required this.mandiLocation,
    required this.state,
    required this.pricePerQuintal,
    required this.previousPrice,
    required this.trend,
    required this.percentChange,
    required this.recommendation,
    required this.aiInsight,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        cropName,
        cropNameLocal,
        mandiName,
        mandiLocation,
        state,
        pricePerQuintal,
        previousPrice,
        trend,
        percentChange,
        recommendation,
        aiInsight,
        updatedAt,
      ];

  MarketPriceEntity copyWith({
    String? id,
    String? cropName,
    String? cropNameLocal,
    String? mandiName,
    String? mandiLocation,
    String? state,
    double? pricePerQuintal,
    double? previousPrice,
    PriceTrend? trend,
    double? percentChange,
    MarketRecommendation? recommendation,
    String? aiInsight,
    DateTime? updatedAt,
  }) {
    return MarketPriceEntity(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      cropNameLocal: cropNameLocal ?? this.cropNameLocal,
      mandiName: mandiName ?? this.mandiName,
      mandiLocation: mandiLocation ?? this.mandiLocation,
      state: state ?? this.state,
      pricePerQuintal: pricePerQuintal ?? this.pricePerQuintal,
      previousPrice: previousPrice ?? this.previousPrice,
      trend: trend ?? this.trend,
      percentChange: percentChange ?? this.percentChange,
      recommendation: recommendation ?? this.recommendation,
      aiInsight: aiInsight ?? this.aiInsight,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MandiEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String state;
  final String district;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final List<String> commodities;
  final String contactNumber;
  final List<String> operatingDays;
  final String operatingHours;

  const MandiEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.state,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.commodities,
    required this.contactNumber,
    required this.operatingDays,
    required this.operatingHours,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        state,
        district,
        latitude,
        longitude,
        distanceKm,
        commodities,
        contactNumber,
        operatingDays,
        operatingHours,
      ];
}
