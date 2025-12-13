import '../entities/market_entity.dart';

abstract class MarketRepository {
  Future<List<MarketPriceEntity>> getMarketPrices({
    String? cropName,
    String? state,
  });
  
  Future<List<MarketPriceEntity>> getCachedPrices();
  
  Future<void> cachePrices(List<MarketPriceEntity> prices);
  
  Future<List<MandiEntity>> getNearbyMandis({
    required double latitude,
    required double longitude,
    double radiusKm = 50,
  });
  
  Future<MarketPriceEntity?> getPriceForCrop({
    required String cropName,
    required String mandiId,
  });
  
  Future<String> getAIMarketInsight({
    required String cropName,
    required List<MarketPriceEntity> recentPrices,
  });
  
  Future<void> clearCache();
}
