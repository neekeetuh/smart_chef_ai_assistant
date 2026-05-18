import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

abstract interface class ClassificationServiceInterface {
  const ClassificationServiceInterface();

  /// Классификация текстовой команды в VoiceCommand с поддержкой контекста
  Future<VoiceCommand> classifyIntent(
    String transcription, {
    List<Recipe>? recipes,
    String? currentUrl,
  });
}
