import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  static GeminiService get instance => _instance;
  GeminiService._internal();

  // TODO: This should be fetched from a secure backend Cloud Function
  // NEVER store API keys in the client app
  // The Cloud Function will proxy requests to Gemini API
  static const String _cloudFunctionUrl = 'https://your-project.cloudfunctions.net/geminiProxy';

  Future<String> generateText({
    required String prompt,
    String? systemInstruction,
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {
    try {
      AppLogger.debug('Generating text with Gemini', tag: 'GeminiService');
      
      final response = await http.post(
        Uri.parse('$_cloudFunctionUrl/generateText'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'systemInstruction': systemInstruction,
          'temperature': temperature,
          'maxTokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? '';
      } else {
        throw AIServiceException(
          message: 'Failed to generate text: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Gemini text generation failed', tag: 'GeminiService', error: e);
      if (e is AIServiceException) rethrow;
      throw AIServiceException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> analyzeImage({
    required File imageFile,
    required String prompt,
    String? systemInstruction,
  }) async {
    try {
      AppLogger.debug('Analyzing image with Gemini Vision', tag: 'GeminiService');
      
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final response = await http.post(
        Uri.parse('$_cloudFunctionUrl/analyzeImage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'mimeType': 'image/jpeg',
          'prompt': prompt,
          'systemInstruction': systemInstruction,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw AIServiceException(
          message: 'Failed to analyze image: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Gemini image analysis failed', tag: 'GeminiService', error: e);
      if (e is AIServiceException) rethrow;
      throw AIServiceException(message: e.toString());
    }
  }

  Future<String> chat({
    required List<Map<String, String>> messages,
    String? systemInstruction,
    double temperature = 0.7,
  }) async {
    try {
      AppLogger.debug('Sending chat to Gemini', tag: 'GeminiService');
      
      final response = await http.post(
        Uri.parse('$_cloudFunctionUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': messages,
          'systemInstruction': systemInstruction,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? '';
      } else {
        throw AIServiceException(
          message: 'Chat request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Gemini chat failed', tag: 'GeminiService', error: e);
      if (e is AIServiceException) rethrow;
      throw AIServiceException(message: e.toString());
    }
  }

  String getDiagnosisPrompt(String cropType, String languageCode) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    
    return '''
Analyze this image of a $cropType plant and provide a detailed diagnosis.
$languageInstruction

Respond in the following JSON format:
{
  "isHealthy": true/false,
  "diseaseName": "name of disease or null if healthy",
  "confidence": 0.0-1.0,
  "severity": "low/medium/high or null if healthy",
  "symptoms": ["list of visible symptoms"],
  "rootCause": "explanation of what causes this issue",
  "treatment": {
    "chemical": {
      "productName": "recommended product",
      "dosage": "amount per application",
      "method": "how to apply",
      "timing": "when to apply",
      "precautions": ["safety precautions"]
    },
    "organic": {
      "name": "organic remedy name",
      "preparation": "how to prepare",
      "application": "how to apply",
      "frequency": "how often"
    },
    "culturalPractices": ["list of farming practices to prevent/treat"]
  },
  "preventionTips": ["list of prevention tips"]
}

Be specific to Indian farming conditions and use locally available products.
''';
  }

  String getFarmingAdvicePrompt(
    Map<String, dynamic> weatherData,
    String? cropType,
    String languageCode,
  ) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    final cropContext = cropType != null ? 'for $cropType crop' : 'for general farming';
    
    return '''
Based on the following weather conditions, provide farming advice $cropContext.
$languageInstruction

Weather Data:
- Temperature: ${weatherData['temperature']}°C
- Humidity: ${weatherData['humidity']}%
- Wind Speed: ${weatherData['windSpeed']} km/h
- Rainfall: ${weatherData['rainfall']} mm
- UV Index: ${weatherData['uvIndex']}

Provide response in JSON format:
{
  "irrigation": {
    "shouldIrrigate": true/false,
    "recommendation": "detailed advice",
    "bestTime": "recommended time"
  },
  "spray": {
    "isSuitable": true/false,
    "recommendation": "detailed advice",
    "bestWindow": "best time window for spraying"
  },
  "generalTips": ["list of weather-specific farming tips"],
  "alerts": [
    {
      "type": "frost/heat/rain/wind",
      "severity": "low/medium/high",
      "message": "warning message",
      "validUntil": "ISO date string"
    }
  ]
}

Consider Indian farming practices and local conditions.
''';
  }

  String _getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'Respond in Hindi (हिन्दी).';
      case 'kn':
        return 'Respond in Kannada (ಕನ್ನಡ).';
      case 'te':
        return 'Respond in Telugu (తెలుగు).';
      case 'ta':
        return 'Respond in Tamil (தமிழ்).';
      default:
        return 'Respond in English.';
    }
  }
}
