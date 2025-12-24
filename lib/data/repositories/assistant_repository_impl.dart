import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/assistant_repository.dart';
import '../datasources/remote/gemini_service.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final GeminiService geminiService;

  AssistantRepositoryImpl({required this.geminiService});

  @override
  Future<ChatMessageEntity> sendMessage(ConversationContext context, String message) async {
    return geminiService.sendMessage(context, message);
  }
}
