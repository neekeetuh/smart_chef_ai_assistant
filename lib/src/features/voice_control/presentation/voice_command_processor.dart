import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/navigation_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/open_recipe_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/theme_command_handler.dart';

class VoiceCommandProcessor {
  final List<VoiceCommandHandler> _handlers;

  VoiceCommandProcessor({List<VoiceCommandHandler>? handlers})
    : _handlers =
          handlers ??
          [
            NavigationCommandHandler(),
            ThemeCommandHandler(),
            OpenRecipeCommandHandler(),
          ];

  void process(BuildContext context, VoiceCommand command) {
    for (final handler in _handlers) {
      if (handler.canHandle(command)) {
        handler.handle(context, command);
        return;
      }
    }
    print('No handler found for command: ${command.action}');
  }
}
