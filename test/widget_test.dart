import 'package:flutter_test/flutter_test.dart';
import 'package:project_kisan/domain/entities/chat_message_entity.dart';
import 'package:project_kisan/domain/entities/market_price_entity.dart';
import 'package:project_kisan/domain/repositories/assistant_repository.dart';
import 'package:project_kisan/domain/repositories/market_repository.dart';

import 'package:project_kisan/main.dart';

class MockMarketRepository implements MarketRepository {
  @override
  Future<List<MarketPriceEntity>> getMarketPrices(
      String crop, String location) async {
    return [];
  }

  @override
  Future<List<String>> getSupportedCrops() async {
    return [];
  }

  @override
  Future<List<String>> getSupportedLocations() async {
    return [];
  }
}

class MockAssistantRepository implements AssistantRepository {
  @override
  Future<void> clearConversation() async {}

  @override
  Future<List<String>> getSuggestedCommands(String? languageCode) async {
    return [];
  }

  @override
  Future<ConversationContext?> loadConversation() async {
    return null;
  }

  @override
  Future<ChatMessageEntity> processVoiceInput(
      {required String audioPath,
      required ConversationContext context,
      String? languageCode}) async {
    return ChatMessageEntity(
      id: '1',
      role: MessageRole.user,
      type: MessageType.text,
      content: 'Hello',
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<void> saveConversation(ConversationContext context) async {}

  @override
  Future<ChatMessageEntity> sendMessage(
      {required String message,
      required ConversationContext context,
      String? languageCode}) async {
    return ChatMessageEntity(
      id: '2',
      role: MessageRole.assistant,
      type: MessageType.text,
      content: 'Hi',
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<String> speechToText(
      {required String audioPath, String? languageCode}) async {
    return 'Hello';
  }

  @override
  Future<String> textToSpeech({required String text, String? languageCode}) async {
    return '';
  }
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProjectKisanApp(
      marketRepository: MockMarketRepository(),
      assistantRepository: MockAssistantRepository(),
    ));

    // Verify that the app builds without crashing.
    expect(find.byType(ProjectKisanApp), findsOneWidget);
  });
}
