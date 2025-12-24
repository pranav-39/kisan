import '../../data/datasources/remote/api_client.dart';
import '../../data/models/market_model.dart';
import '../../domain/entities/market_entity.dart';
import '../../domain/repositories/market_repository.dart';

class MarketRepositoryImpl implements MarketRepository {
  final ApiClient apiClient;

  MarketRepositoryImpl({required this.apiClient});

  @override
  Future<List<MarketPriceEntity>> getMarketPrices() async {
    final response = await apiClient.get('/market-prices');
    final data = response['data'] as List;
    return data.map((json) => MarketPriceModel.fromJson(json)).toList();
  }
}
