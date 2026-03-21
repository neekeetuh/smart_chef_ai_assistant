import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class OpenRecipeCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.openRecipe;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    if (command.parameters.isNotEmpty) {
      context.router.push(RecipeDetailRoute(recipeId: command.parameters));
    }
  }
}
