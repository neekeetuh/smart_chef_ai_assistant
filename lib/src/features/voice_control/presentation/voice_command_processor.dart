import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/navigation_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/open_recipe_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/theme_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/help_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/recipe_step_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/handlers/favorite_command_handler.dart';

class VoiceCommandProcessor {
  final List<VoiceCommandHandler> _handlers;

  VoiceCommandProcessor({List<VoiceCommandHandler>? handlers})
    : _handlers =
          handlers ??
          [
            NavigationCommandHandler(),
            ThemeCommandHandler(),
            OpenRecipeCommandHandler(),
            RecipeStepCommandHandler(),
            FavoriteCommandHandler(),
            HelpCommandHandler(),
          ];

  bool process(BuildContext context, VoiceCommand command) {
    if (command.action == VoiceAction.unknown) {
      developer.log('Unknown action', name: 'VoiceCommandProcessor');
      return false;
    }

    for (final handler in _handlers) {
      if (handler.canHandle(command)) {
        handler.handle(context, command);
        return true;
      }
    }
    developer.log('No handler found for ${command.action}', name: 'VoiceCommandProcessor');
    return false;
  }
}
