import '../../domain/entities/chat_message_entity.dart';

abstract class AssistantRepository {
  Future<ChatMessageEntity> sendMessage(ConversationContext context, String message);
}
