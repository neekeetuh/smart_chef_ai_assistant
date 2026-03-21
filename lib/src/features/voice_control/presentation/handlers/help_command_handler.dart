import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/voice_help_bottom_sheet.dart';

class HelpCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.help;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    VoiceHelpBottomSheet.show(context);
  }
}
