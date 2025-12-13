import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  static HiveService get instance => _instance;
  HiveService._internal();

  late Box _settingsBox;
  late Box _diagnosisBox;
  late Box _weatherBox;
  late Box _marketBox;
  late Box _offlineQueueBox;

  Future<void> init() async {
    _settingsBox = await Hive.openBox(HiveBoxNames.settings);
    _diagnosisBox = await Hive.openBox(HiveBoxNames.diagnosisHistory);
    _weatherBox = await Hive.openBox(HiveBoxNames.weatherCache);
    _marketBox = await Hive.openBox(HiveBoxNames.marketCache);
    _offlineQueueBox = await Hive.openBox(HiveBoxNames.offlineQueue);
  }

  Box get settingsBox => _settingsBox;
  Box get diagnosisBox => _diagnosisBox;
  Box get weatherBox => _weatherBox;
  Box get marketBox => _marketBox;
  Box get offlineQueueBox => _offlineQueueBox;

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> saveDiagnosis(String id, Map<String, dynamic> data) async {
    await _diagnosisBox.put(id, data);
    await _enforceHistoryLimit();
  }

  Map<String, dynamic>? getDiagnosis(String id) {
    final data = _diagnosisBox.get(id);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  List<Map<String, dynamic>> getAllDiagnoses() {
    return _diagnosisBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> deleteDiagnosis(String id) async {
    await _diagnosisBox.delete(id);
  }

  Future<void> clearDiagnosisHistory() async {
    await _diagnosisBox.clear();
  }

  Future<void> _enforceHistoryLimit() async {
    if (_diagnosisBox.length > AppConstants.maxDiagnosisHistory) {
      final entries = _diagnosisBox.toMap().entries.toList();
      entries.sort((a, b) {
        final aDate = DateTime.tryParse(a.value['diagnosedAt'] ?? '') ?? DateTime(2000);
        final bDate = DateTime.tryParse(b.value['diagnosedAt'] ?? '') ?? DateTime(2000);
        return aDate.compareTo(bDate);
      });

      final toDelete = entries.take(entries.length - AppConstants.maxDiagnosisHistory);
      for (final entry in toDelete) {
        await _diagnosisBox.delete(entry.key);
      }
    }
  }

  Future<void> cacheWeather(Map<String, dynamic> data) async {
    await _weatherBox.put('current', data);
    await _weatherBox.put('timestamp', DateTime.now().toIso8601String());
  }

  Map<String, dynamic>? getCachedWeather() {
    final data = _weatherBox.get('current');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  DateTime? getWeatherCacheTimestamp() {
    final timestamp = _weatherBox.get('timestamp') as String?;
    return timestamp != null ? DateTime.tryParse(timestamp) : null;
  }

  bool isWeatherCacheValid({Duration maxAge = const Duration(minutes: 30)}) {
    final timestamp = getWeatherCacheTimestamp();
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < maxAge;
  }

  Future<void> clearWeatherCache() async {
    await _weatherBox.clear();
  }

  Future<void> cacheMarketPrices(List<Map<String, dynamic>> prices) async {
    await _marketBox.put('prices', prices);
    await _marketBox.put('timestamp', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>> getCachedMarketPrices() {
    final data = _marketBox.get('prices');
    if (data == null) return [];
    return (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  bool isMarketCacheValid({Duration maxAge = const Duration(hours: 1)}) {
    final timestamp = _marketBox.get('timestamp') as String?;
    if (timestamp == null) return false;
    final cacheTime = DateTime.tryParse(timestamp);
    if (cacheTime == null) return false;
    return DateTime.now().difference(cacheTime) < maxAge;
  }

  Future<void> clearMarketCache() async {
    await _marketBox.clear();
  }

  Future<void> addToOfflineQueue(Map<String, dynamic> item) async {
    final queue = getOfflineQueue();
    if (queue.length >= AppConstants.maxOfflineQueueSize) {
      queue.removeAt(0);
    }
    queue.add(item);
    await _offlineQueueBox.put('queue', queue);
  }

  List<Map<String, dynamic>> getOfflineQueue() {
    final data = _offlineQueueBox.get('queue');
    if (data == null) return [];
    return (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> removeFromOfflineQueue(String id) async {
    final queue = getOfflineQueue();
    queue.removeWhere((item) => item['id'] == id);
    await _offlineQueueBox.put('queue', queue);
  }

  Future<void> clearOfflineQueue() async {
    await _offlineQueueBox.clear();
  }

  Future<void> closeAll() async {
    await _settingsBox.close();
    await _diagnosisBox.close();
    await _weatherBox.close();
    await _marketBox.close();
    await _offlineQueueBox.close();
  }
}
