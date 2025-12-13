import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/voice_assistant_provider.dart';
import '../screens/assistant/voice_assistant_sheet.dart';

class FloatingVoiceButton extends StatelessWidget {
  const FloatingVoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (context, provider, child) {
        return FloatingActionButton(
          onPressed: () => _showVoiceAssistant(context),
          backgroundColor: provider.isListening
              ? AppColors.error
              : provider.isProcessing
                  ? AppColors.warning
                  : AppColors.primary,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              provider.isListening
                  ? Icons.stop
                  : provider.isProcessing
                      ? Icons.hourglass_empty
                      : Icons.mic,
              key: ValueKey(provider.state),
            ),
          ),
        );
      },
    );
  }

  void _showVoiceAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceAssistantSheet(),
    );
  }
}
