import 'package:equatable/equatable.dart';

class MarketPriceEntity extends Equatable {
  final String cropName;
  final String marketName;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final DateTime lastUpdated;

  const MarketPriceEntity({
    required this.cropName,
    required this.marketName,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.lastUpdated,
  });

  factory MarketPriceEntity.fromJson(Map<String, dynamic> json) {
    return MarketPriceEntity(
      cropName: json['commodity'] as String,
      marketName: json['market'] as String,
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      modalPrice: (json['modal_price'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['arrival_date'] as String),
    );
  }

  @override
  List<Object?> get props => [
        cropName,
        marketName,
        minPrice,
        maxPrice,
        modalPrice,
        lastUpdated,
      ];
}
