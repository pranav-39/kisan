import 'package:dio/dio.dart';
import 'package:project_kisan/core/errors/exceptions.dart';

class AgmarknetApiClient {
  final Dio _dio;
  static const String _apiKey = '579b464db66ec23bdd00000160514dc20f654b6c4c77e028dd596224';
  static const String _baseUrl = 'https://api.agmarknet.gov.in/v1/services';

  AgmarknetApiClient(this._dio);

  Future<List<dynamic>> getMarketPrices({
    required String cropCode,
    required String stateCode,
    required String districtCode,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getMarketArrivals',
        queryParameters: {
          'api_key': _apiKey,
          'format': 'json',
          'commodity': cropCode,
          'state': stateCode,
          'district': districtCode,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['results'] is List) {
          return data['results'];
        } else {
          throw const ServerException(message: 'Invalid API response format');
        }
      } else {
        throw ServerException(message: 'Failed to load market prices: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect to Agmarknet API');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<dynamic>> getCommodities() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getCommodities',
        queryParameters: {
          'api_key': _apiKey,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['results'] is List) {
          return data['results'];
        } else {
          throw const ServerException(message: 'Invalid API response format');
        }
      } else {
        throw ServerException(message: 'Failed to load commodities: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect to Agmarknet API');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<dynamic>> getStates() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getStates',
        queryParameters: {
          'api_key': _apiKey,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['results'] is List) {
          return data['results'];
        } else {
          throw const ServerException(message: 'Invalid API response format');
        }
      } else {
        throw ServerException(message: 'Failed to load states: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect to Agmarknet API');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<dynamic>> getDistricts(String stateId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getDistricts',
        queryParameters: {
          'api_key': _apiKey,
          'format': 'json',
          'state': stateId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['results'] is List) {
          return data['results'];
        } else {
          throw const ServerException(message: 'Invalid API response format');
        }
      } else {
        throw ServerException(message: 'Failed to load districts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect to Agmarknet API');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
