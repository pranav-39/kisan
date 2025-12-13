import 'package:flutter/material.dart';
import '../../domain/entities/market_entity.dart';
import '../../data/models/market_model.dart';
import '../../data/datasources/local/hive_service.dart';

enum MarketLoadingState {
  initial,
  loading,
  loaded,
  error,
}

class MarketProvider extends ChangeNotifier {
  MarketLoadingState _state = MarketLoadingState.initial;
  List<MarketPriceEntity> _prices = [];
  String? _errorMessage;
  String? _selectedCrop;
  String? _selectedState;
  
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
      filtered = filtered.where((p) => 
        p.cropName.toLowerCase() == _selectedCrop!.toLowerCase()
      ).toList();
    }
    
    if (_selectedState != null) {
      filtered = filtered.where((p) => 
        p.state.toLowerCase() == _selectedState!.toLowerCase()
      ).toList();
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
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = _loadFromCache();
        if (cached.isNotEmpty) {
          _prices = cached;
          _state = MarketLoadingState.loaded;
          notifyListeners();
          return;
        }
      }
      
      // TODO: Fetch from actual market price API
      // This is mock data for demonstration
      _prices = _getMockMarketData();
      
      // Cache the prices
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
      return cachedData.map((e) => MarketPriceModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading market prices from cache: $e');
      return [];
    }
  }
  
  Future<void> _saveToCache(List<MarketPriceEntity> prices) async {
    try {
      final models = prices.map((e) => 
        MarketPriceModel.fromEntity(e).toJson()
      ).toList();
      await HiveService.instance.cacheMarketPrices(models);
    } catch (e) {
      debugPrint('Error saving market prices to cache: $e');
    }
  }
  
  List<MarketPriceEntity> _getMockMarketData() {
    final now = DateTime.now();
    
    return [
      MarketPriceEntity(
        id: '1',
        cropName: 'Wheat',
        cropNameLocal: 'गेहूं',
        mandiName: 'Azadpur Mandi',
        mandiLocation: 'Delhi',
        state: 'Delhi',
        pricePerQuintal: 2450,
        previousPrice: 2380,
        trend: PriceTrend.up,
        percentChange: 2.94,
        recommendation: MarketRecommendation.hold,
        aiInsight: 'Prices trending upward due to increased demand. Hold for better prices.',
        updatedAt: now,
      ),
      MarketPriceEntity(
        id: '2',
        cropName: 'Rice',
        cropNameLocal: 'धान',
        mandiName: 'Karnal Mandi',
        mandiLocation: 'Karnal',
        state: 'Haryana',
        pricePerQuintal: 2100,
        previousPrice: 2150,
        trend: PriceTrend.down,
        percentChange: -2.33,
        recommendation: MarketRecommendation.hold,
        aiInsight: 'Slight price correction after recent highs. Expected to stabilize.',
        updatedAt: now,
      ),
      MarketPriceEntity(
        id: '3',
        cropName: 'Tomato',
        cropNameLocal: 'टमाटर',
        mandiName: 'Vashi APMC',
        mandiLocation: 'Mumbai',
        state: 'Maharashtra',
        pricePerQuintal: 1800,
        previousPrice: 1500,
        trend: PriceTrend.up,
        percentChange: 20.0,
        recommendation: MarketRecommendation.sell,
        aiInsight: 'Sharp price increase due to supply shortage. Good time to sell.',
        updatedAt: now,
      ),
      MarketPriceEntity(
        id: '4',
        cropName: 'Onion',
        cropNameLocal: 'प्याज',
        mandiName: 'Lasalgaon Mandi',
        mandiLocation: 'Nashik',
        state: 'Maharashtra',
        pricePerQuintal: 1200,
        previousPrice: 1200,
        trend: PriceTrend.stable,
        percentChange: 0.0,
        recommendation: MarketRecommendation.hold,
        aiInsight: 'Prices stable. No major movement expected this week.',
        updatedAt: now,
      ),
      MarketPriceEntity(
        id: '5',
        cropName: 'Cotton',
        cropNameLocal: 'कपास',
        mandiName: 'Rajkot Mandi',
        mandiLocation: 'Rajkot',
        state: 'Gujarat',
        pricePerQuintal: 6500,
        previousPrice: 6200,
        trend: PriceTrend.up,
        percentChange: 4.84,
        recommendation: MarketRecommendation.sell,
        aiInsight: 'Strong demand from textile industry. Favorable time to sell.',
        updatedAt: now,
      ),
      MarketPriceEntity(
        id: '6',
        cropName: 'Soybean',
        cropNameLocal: 'सोयाबीन',
        mandiName: 'Indore Mandi',
        mandiLocation: 'Indore',
        state: 'Madhya Pradesh',
        pricePerQuintal: 4800,
        previousPrice: 4900,
        trend: PriceTrend.down,
        percentChange: -2.04,
        recommendation: MarketRecommendation.hold,
        aiInsight: 'Minor correction. Long-term outlook remains positive.',
        updatedAt: now,
      ),
    ];
  }
  
  void clearCache() {
    HiveService.instance.clearMarketCache();
    _prices = [];
    _state = MarketLoadingState.initial;
    notifyListeners();
  }
}
