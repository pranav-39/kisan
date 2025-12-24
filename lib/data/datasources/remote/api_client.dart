import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();

  // This should be set from a secure configuration, such as Firebase Remote Config or environment variables.
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);
      
      AppLogger.debug('GET: $uri', tag: 'ApiClient');
      
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(AppConstants.apiTimeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint')
          .replace(queryParameters: queryParams);
      
      AppLogger.debug('POST: $uri', tag: 'ApiClient');
      
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConstants.apiTimeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> postWithFile(
    String endpoint, {
    required File file,
    required String fileFieldName,
    Map<String, String>? fields,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      
      AppLogger.debug('POST (multipart): $uri', tag: 'ApiClient');
      
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_headers);
      
      if (fields != null) {
        request.fields.addAll(fields);
      }
      
      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
      ));
      
      final streamedResponse = await request.send().timeout(AppConstants.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    AppLogger.debug(
      'Response [${response.statusCode}]: ${response.body.substring(0, response.body.length.clamp(0, 200))}',
      tag: 'ApiClient',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    switch (response.statusCode) {
      case 401:
        throw const AuthException(message: 'Unauthorized');
      case 403:
        throw const AuthException(message: 'Forbidden');
      case 404:
        throw const ServerException(message: 'Resource not found');
      case 422:
        final body = jsonDecode(response.body);
        throw ValidationException(
          message: body['message'] ?? 'Validation failed',
          fieldErrors: body['errors'] != null
              ? Map<String, String>.from(body['errors'])
              : null,
        );
      case 500:
      case 502:
      case 503:
        throw const ServerException(message: 'Server error. Please try again later.');
      default:
        throw ServerException(
          message: 'Request failed with status: ${response.statusCode}',
        );
    }
  }

  void dispose() {
    _client.close();
  }
}
