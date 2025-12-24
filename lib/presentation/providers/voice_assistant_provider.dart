import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/assistant_repository.dart';

enum VoiceAssistantState {
  idle,
  listening,
  processing,
  speaking,
  error,
}

class VoiceAssistantProvider extends ChangeNotifier {
  final AssistantRepository assistantRepository;
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  VoiceAssistantState _state = VoiceAssistantState.idle;
  ConversationContext _context = const ConversationContext();
  String? _errorMessage;
  bool _isMicAvailable = false;

  VoiceAssistantProvider({required this.assistantRepository}) {
    _initSpeech();
    _initTts();
  }

  void _initSpeech() async {
    _isMicAvailable = await _speechToText.initialize(
      onError: (error) => _handleError(error.errorMsg),
    );
    notifyListeners();
  }

  void _initTts() {
    _flutterTts.setCompletionHandler(() {
      _state = VoiceAssistantState.idle;
      notifyListeners();
    });
  }

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

  Future<void> startListening() async {
    if (!_isMicAvailable || _state == VoiceAssistantState.listening) return;

    _state = VoiceAssistantState.listening;
    _errorMessage = null;
    notifyListeners();

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          sendTextMessage(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    );
  }

  Future<void> stopListening() async {
    if (_state == VoiceAssistantState.listening) {
      await _speechToText.stop();
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
      final assistantMessage = await assistantRepository.sendMessage(_context, text);
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

    try {
      // TODO: Convert audio to text
      final text = await _audioToText(audioPath);
      final assistantMessage = await assistantRepository.sendMessage(_context, text);
      _addMessage(assistantMessage);
      await _speak(assistantMessage.content);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<String> _audioToText(String audioPath) {
    // This is a placeholder. In a real app, you would use a speech-to-text service
    // to convert the audio at `audioPath` to text.
    return Future.delayed(const Duration(seconds: 1), () => 'What is the price of wheat?');
  }

  Future<void> _speak(String text) async {
    _state = VoiceAssistantState.speaking;
    notifyListeners();
    await _flutterTts.speak(text);
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

  List<String> getSuggestedCommands() {
    return [
      'What is the price of wheat today?',
      'Should I irrigate my field tomorrow?',
      'Scan my tomato plant for diseases',
      'What\'s the weather forecast?',
      'Tell me about PM-KISAN scheme',
    ];
  }

  void _handleError(String message) {
    _state = VoiceAssistantState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
