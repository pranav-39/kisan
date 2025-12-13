import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message_entity.dart';

enum VoiceAssistantState {
  idle,
  listening,
  processing,
  speaking,
  error,
}

class VoiceAssistantProvider extends ChangeNotifier {
  VoiceAssistantState _state = VoiceAssistantState.idle;
  ConversationContext _context = const ConversationContext();
  String? _errorMessage;
  bool _isMicAvailable = true;
  String _languageCode = 'en';
  
  VoiceAssistantState get state => _state;
  ConversationContext get context => _context;
  List<ChatMessageEntity> get messages => _context.messages;
  String? get errorMessage => _errorMessage;
  bool get isMicAvailable => _isMicAvailable;
  bool get isIdle => _state == VoiceAssistantState.idle;
  bool get isListening => _state == VoiceAssistantState.listening;
  bool get isProcessing => _state == VoiceAssistantState.processing;
  bool get isSpeaking => _state == VoiceAssistantState.speaking;
  bool get hasError => _state == VoiceAssistantState.error;
  
  void setLanguageCode(String code) {
    _languageCode = code;
    notifyListeners();
  }
  
  Future<void> startListening() async {
    _state = VoiceAssistantState.listening;
    _errorMessage = null;
    notifyListeners();
    
    // TODO: Implement actual speech-to-text using speech_to_text package
    // This is a stub implementation
  }
  
  Future<void> stopListening() async {
    if (_state == VoiceAssistantState.listening) {
      _state = VoiceAssistantState.idle;
      notifyListeners();
    }
  }
  
  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    final userMessage = ChatMessageEntity(
      id: const Uuid().v4(),
      role: MessageRole.user,
      type: MessageType.text,
      content: text,
      timestamp: DateTime.now(),
    );
    
    _addMessage(userMessage);
    _state = VoiceAssistantState.processing;
    notifyListeners();
    
    try {
      // TODO: Call actual Gemini API through repository
      // This is a stub implementation
      await Future.delayed(const Duration(seconds: 1));
      
      final assistantMessage = ChatMessageEntity(
        id: const Uuid().v4(),
        role: MessageRole.assistant,
        type: MessageType.text,
        content: _getStubResponse(text),
        timestamp: DateTime.now(),
      );
      
      _addMessage(assistantMessage);
      _state = VoiceAssistantState.idle;
    } catch (e) {
      _state = VoiceAssistantState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<void> sendVoiceMessage(String audioPath) async {
    _state = VoiceAssistantState.processing;
    notifyListeners();
    
    // TODO: Implement actual voice processing
    // 1. Convert audio to text using speech-to-text
    // 2. Send to Gemini API
    // 3. Convert response to speech using TTS
    
    await Future.delayed(const Duration(seconds: 2));
    
    _state = VoiceAssistantState.idle;
    notifyListeners();
  }
  
  void _addMessage(ChatMessageEntity message) {
    final updatedMessages = [..._context.messages, message];
    _context = _context.copyWith(messages: updatedMessages);
  }
  
  void clearConversation() {
    _context = const ConversationContext();
    _state = VoiceAssistantState.idle;
    _errorMessage = null;
    notifyListeners();
  }
  
  void setCurrentCrop(String cropType) {
    _context = _context.copyWith(currentCrop: cropType);
    notifyListeners();
  }
  
  void setCurrentLocation(String location) {
    _context = _context.copyWith(currentLocation: location);
    notifyListeners();
  }
  
  String _getStubResponse(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('price') || lowerInput.contains('mandi')) {
      return 'Based on current market data, wheat is trading at Rs 2,450 per quintal at Azadpur Mandi. Prices have increased by 3% this week. I recommend holding for now as prices may rise further.';
    }
    
    if (lowerInput.contains('weather') || lowerInput.contains('rain')) {
      return 'Today\'s weather shows clear skies with temperature around 28°C. No rain expected for the next 3 days. This is a good time for pesticide spraying. Best time would be early morning between 6-9 AM.';
    }
    
    if (lowerInput.contains('disease') || lowerInput.contains('scan')) {
      return 'To scan your crop for diseases, please tap the "Scan Crop" button on the home screen and take a clear photo of the affected leaves or plant parts.';
    }
    
    if (lowerInput.contains('irrigat')) {
      return 'Based on current weather conditions and soil moisture levels, I recommend irrigating your fields tomorrow morning. The humidity is low and no rain is expected.';
    }
    
    if (lowerInput.contains('scheme') || lowerInput.contains('pm kisan')) {
      return 'PM-KISAN provides Rs 6,000 per year to eligible farmers in 3 installments. To check eligibility and apply, visit your local CSC center or apply online at pmkisan.gov.in with your Aadhaar and land records.';
    }
    
    return 'I\'m here to help you with farming advice, crop diseases, weather updates, market prices, and government schemes. How can I assist you today?';
  }
  
  List<String> getSuggestedCommands() {
    return [
      'What is the price of wheat today?',
      'Should I irrigate my field tomorrow?',
      'Scan my tomato plant for diseases',
      'What\'s the weather forecast?',
      'Tell me about PM-KISAN scheme',
    ];
  }
}
