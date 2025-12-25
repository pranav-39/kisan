import 'package:flutter/material.dart';
import '../../domain/entities/market_price_entity.dart';
import '../../domain/repositories/market_repository.dart';

enum MarketLoadingState {
  initial,
  loading,
  loaded,
  error,
}

class MarketProvider extends ChangeNotifier {
  final MarketRepository _marketRepository;

  MarketLoadingState _state = MarketLoadingState.initial;
  List<MarketPriceEntity> _prices = [];
  String? _errorMessage;
  String? _selectedCrop;
  String? _selectedLocation;

  MarketProvider(this._marketRepository);

  MarketLoadingState get state => _state;
  List<MarketPriceEntity> get prices => _prices;
  String? get errorMessage => _errorMessage;
  String? get selectedCrop => _selectedCrop;
  String? get selectedLocation => _selectedLocation;

  Future<void> loadMarketPrices({String? crop, String? location}) async {
    _state = MarketLoadingState.loading;
    notifyListeners();

    try {
      _prices = await _marketRepository.getMarketPrices(crop ?? '', location ?? '');
      _state = MarketLoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = MarketLoadingState.error;
    }

    notifyListeners();
  }

  void setSelectedCrop(String? crop) {
    _selectedCrop = crop;
    loadMarketPrices(crop: _selectedCrop, location: _selectedLocation);
  }

  void setSelectedLocation(String? location) {
    _selectedLocation = location;
    loadMarketPrices(crop: _selectedCrop, location: _selectedLocation);
  }
}
