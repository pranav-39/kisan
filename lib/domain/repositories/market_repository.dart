import '../entities/market_price_entity.dart';

abstract class MarketRepository {
  Future<List<MarketPriceEntity>> getMarketPrices(String crop, String location);

  Future<List<String>> getSupportedCrops();

  Future<List<String>> getSupportedLocations();
}
