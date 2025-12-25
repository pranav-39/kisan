import 'package:project_kisan/domain/entities/market_price_entity.dart';
import 'package:project_kisan/domain/repositories/market_repository.dart';
import '../datasources/remote/agmarknet_api_client.dart';

class MarketRepositoryImpl implements MarketRepository {
  final AgmarknetApiClient _apiClient;

  MarketRepositoryImpl(this._apiClient);

  @override
  Future<List<MarketPriceEntity>> getMarketPrices(
      String crop, String location) async {
    // TODO: Implement location to state/district mapping
    final prices = await _apiClient.getMarketPrices(
      cropCode: crop, // This needs to be a valid crop code
      stateCode: 'MH', // Placeholder state code
      districtCode: 'PUN', // Placeholder district code
    );

    return prices.map((price) => MarketPriceEntity.fromJson(price)).toList();
  }

  @override
  Future<List<String>> getSupportedCrops() async {
    // TODO: Fetch from API or a local list
    return [
      'Wheat',
      'Paddy',
      'Cotton',
      'Maize',
      'Sugarcane',
    ];
  }

  @override
  Future<List<String>> getSupportedLocations() async {
    // TODO: Fetch from API or a local list
    return [
      'Pune',
      'Mumbai',
      'Nagpur',
      'Nashik',
      'Aurangabad',
    ];
  }
}
