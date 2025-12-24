import '../entities/market_entity.dart';

abstract class MarketRepository {
  Future<List<MarketPriceEntity>> getMarketPrices();
}
