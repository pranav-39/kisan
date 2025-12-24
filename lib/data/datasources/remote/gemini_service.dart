import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../domain/entities/chat_message_entity.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  static GeminiService get instance => _instance;
  GeminiService._internal();

  final Gemini _gemini = Gemini.instance;

  Future<ChatMessageEntity> sendMessage(ConversationContext context, String message) async {
    final chatMessages = context.messages.map((m) => Content(parts: [Parts(text: m.content)], role: m.role == MessageRole.user ? 'user' : 'model')).toList();
    final response = await _gemini.chat(chatMessages);

    return ChatMessageEntity(
      id: response.hashCode.toString(),
      role: MessageRole.assistant,
      type: MessageType.text,
      content: response?.output ?? 'Sorry, I could not process your request.',
      timestamp: DateTime.now(),
    );
  }
}
