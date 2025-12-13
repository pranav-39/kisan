import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }
enum MessageType { text, voice, action }

class ChatMessageEntity extends Equatable {
  final String id;
  final MessageRole role;
  final MessageType type;
  final String content;
  final String? audioPath;
  final String? actionType;
  final Map<String, dynamic>? actionData;
  final DateTime timestamp;
  final bool isProcessing;
  final String? errorMessage;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.type,
    required this.content,
    this.audioPath,
    this.actionType,
    this.actionData,
    required this.timestamp,
    this.isProcessing = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        id,
        role,
        type,
        content,
        audioPath,
        actionType,
        actionData,
        timestamp,
        isProcessing,
        errorMessage,
      ];

  ChatMessageEntity copyWith({
    String? id,
    MessageRole? role,
    MessageType? type,
    String? content,
    String? audioPath,
    String? actionType,
    Map<String, dynamic>? actionData,
    DateTime? timestamp,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      type: type ?? this.type,
      content: content ?? this.content,
      audioPath: audioPath ?? this.audioPath,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      timestamp: timestamp ?? this.timestamp,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isUserMessage => role == MessageRole.user;
  bool get isAssistantMessage => role == MessageRole.assistant;
  bool get hasError => errorMessage != null;
}

class ConversationContext {
  final List<ChatMessageEntity> messages;
  final String? currentCrop;
  final String? currentLocation;
  final Map<String, dynamic> sessionData;

  const ConversationContext({
    this.messages = const [],
    this.currentCrop,
    this.currentLocation,
    this.sessionData = const {},
  });

  List<Map<String, String>> toApiFormat({int maxTurns = 10}) {
    final relevantMessages = messages.length > maxTurns * 2
        ? messages.sublist(messages.length - maxTurns * 2)
        : messages;

    return relevantMessages
        .where((m) => m.role != MessageRole.system && !m.isProcessing)
        .map((m) => {
              'role': m.role == MessageRole.user ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();
  }

  ConversationContext copyWith({
    List<ChatMessageEntity>? messages,
    String? currentCrop,
    String? currentLocation,
    Map<String, dynamic>? sessionData,
  }) {
    return ConversationContext(
      messages: messages ?? this.messages,
      currentCrop: currentCrop ?? this.currentCrop,
      currentLocation: currentLocation ?? this.currentLocation,
      sessionData: sessionData ?? this.sessionData,
    );
  }
}
