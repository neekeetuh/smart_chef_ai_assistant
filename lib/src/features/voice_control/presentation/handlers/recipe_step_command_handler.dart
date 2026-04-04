import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

/// Обработчик шагов рецепта.
/// Сама логика переключения находится в RecipeStepView через BlocListener.
/// Этот класс нужен только для того, чтобы VoiceCommandProcessor 
/// пометил команду как успешно обработанную и не открывал справку.
class RecipeStepCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) =>
      command.action == VoiceAction.recipeStep ||
      command.action == VoiceAction.readStep;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    // Ничего не делаем, обработано на уровне виджета
  }
}
