import 'package:flutter/material.dart';

import '../../data/datasources/local/hive_service.dart';
import '../../data/models/market_model.dart';
import '../../domain/entities/market_entity.dart';
import '../../domain/repositories/market_repository.dart';

enum MarketLoadingState {
  initial,
  loading,
  loaded,
  error,
}

class MarketProvider extends ChangeNotifier {
  final MarketRepository marketRepository;

  MarketLoadingState _state = MarketLoadingState.initial;
  List<MarketPriceEntity> _prices = [];
  String? _errorMessage;
  String? _selectedCrop;
  String? _selectedState;

  MarketProvider({required this.marketRepository});

  MarketLoadingState get state => _state;
  List<MarketPriceEntity> get prices => _filteredPrices;
  List<MarketPriceEntity> get allPrices => _prices;
  String? get errorMessage => _errorMessage;
  String? get selectedCrop => _selectedCrop;
  String? get selectedState => _selectedState;
  bool get isLoading => _state == MarketLoadingState.loading;
  bool get hasData => _prices.isNotEmpty;
  bool get hasError => _state == MarketLoadingState.error;

  List<MarketPriceEntity> get _filteredPrices {
    var filtered = _prices;

    if (_selectedCrop != null) {
      filtered = filtered
          .where((p) => p.cropName.toLowerCase() == _selectedCrop!.toLowerCase())
          .toList();
    }

    if (_selectedState != null) {
      filtered = filtered
          .where((p) => p.state.toLowerCase() == _selectedState!.toLowerCase())
          .toList();
    }

    return filtered;
  }

  List<String> get availableCrops {
    return _prices.map((p) => p.cropName).toSet().toList()..sort();
  }

  List<String> get availableStates {
    return _prices.map((p) => p.state).toSet().toList()..sort();
  }

  Future<void> loadMarketPrices({bool forceRefresh = false}) async {
    if (_state == MarketLoadingState.loading) return;

    _state = MarketLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!forceRefresh) {
        final cached = _loadFromCache();
        if (cached.isNotEmpty) {
          _prices = cached;
          _state = MarketLoadingState.loaded;
          notifyListeners();
          return;
        }
      }

      _prices = await marketRepository.getMarketPrices();

      await _saveToCache(_prices);

      _state = MarketLoadingState.loaded;
    } catch (e) {
      _state = MarketLoadingState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void setSelectedCrop(String? crop) {
    _selectedCrop = crop;
    notifyListeners();
  }

  void setSelectedState(String? state) {
    _selectedState = state;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCrop = null;
    _selectedState = null;
    notifyListeners();
  }

  List<MarketPriceEntity> _loadFromCache() {
    try {
      if (!HiveService.instance.isMarketCacheValid()) {
        return [];
      }

      final cachedData = HiveService.instance.getCachedMarketPrices();
      return cachedData.map(MarketPriceModel.fromJson).toList();
    } catch (e) {
      debugPrint('Error loading market prices from cache: $e');
      return [];
    }
  }

  Future<void> _saveToCache(List<MarketPriceEntity> prices) async {
    try {
      final models =
          prices.map((e) => MarketPriceModel.fromEntity(e).toJson()).toList();
      await HiveService.instance.cacheMarketPrices(models);
    } catch (e) {
      debugPrint('Error saving market prices to cache: $e');
    }
  }

  void clearCache() {
    HiveService.instance.clearMarketCache();
    _prices = [];
    _state = MarketLoadingState.initial;
    notifyListeners();
  }
}
