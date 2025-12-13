import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../providers/voice_assistant_provider.dart';

class VoiceAssistantSheet extends StatefulWidget {
  const VoiceAssistantSheet({super.key});

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Consumer<VoiceAssistantProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildHeader(context, provider, localizations),
              Expanded(
                child: provider.messages.isEmpty
                    ? _buildEmptyState(context, provider, localizations)
                    : _buildMessageList(context, provider),
              ),
              _buildInputArea(context, provider, localizations, bottomPadding),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    VoiceAssistantProvider provider,
    AppLocalizations? loc,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.assistant, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc?.voiceAssistant ?? 'Voice Assistant',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getStatusText(provider, loc),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => provider.clearConversation(),
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Clear conversation',
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _getStatusText(VoiceAssistantProvider provider, AppLocalizations? loc) {
    switch (provider.state) {
      case VoiceAssistantState.listening:
        return loc?.listening ?? 'Listening...';
      case VoiceAssistantState.processing:
        return loc?.processing ?? 'Processing...';
      case VoiceAssistantState.speaking:
        return 'Speaking...';
      case VoiceAssistantState.error:
        return 'Error occurred';
      default:
        return loc?.tapToSpeak ?? 'Tap to speak';
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    VoiceAssistantProvider provider,
    AppLocalizations? loc,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'How can I help you today?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            loc?.voiceCommandHint ??
                'Try: "What is the price of wheat?" or "Scan my tomato plant"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'Suggested Commands',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: provider.getSuggestedCommands().map((command) {
              return ActionChip(
                label: Text(command),
                onPressed: () => provider.sendTextMessage(command),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    VoiceAssistantProvider provider,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final message = provider.messages[index];
        return _MessageBubble(message: message);
      },
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    VoiceAssistantProvider provider,
    AppLocalizations? loc,
    double bottomPadding,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  provider.sendTextMessage(text);
                  _textController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                provider.sendTextMessage(_textController.text);
                _textController.clear();
              } else if (provider.isListening) {
                provider.stopListening();
              } else {
                provider.startListening();
              }
            },
            backgroundColor: provider.isListening
                ? AppColors.error
                : AppColors.primary,
            child: Icon(
              _textController.text.isNotEmpty
                  ? Icons.send
                  : provider.isListening
                      ? Icons.stop
                      : Icons.mic,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUserMessage;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isProcessing)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Processing...'),
                ],
              )
            else
              Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : null,
                ),
              ),
            if (message.hasError) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    message.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
