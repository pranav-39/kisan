import '../entities/chat_message_entity.dart';

abstract class AssistantRepository {
  Future<ChatMessageEntity> sendMessage({
    required String message,
    required ConversationContext context,
    String? languageCode,
  });
  
  Future<ChatMessageEntity> processVoiceInput({
    required String audioPath,
    required ConversationContext context,
    String? languageCode,
  });
  
  Future<String> textToSpeech({
    required String text,
    String? languageCode,
  });
  
  Future<String> speechToText({
    required String audioPath,
    String? languageCode,
  });
  
  Future<void> saveConversation(ConversationContext context);
  
  Future<ConversationContext?> loadConversation();
  
  Future<void> clearConversation();
  
  Future<List<String>> getSuggestedCommands(String? languageCode);
}
