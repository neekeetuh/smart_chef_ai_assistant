import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipe_generator/data/services/ai_recipe_generator_service.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class GenerateRecipeCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.generateRecipe;

  @override
  void handle(BuildContext context, VoiceCommand command) async {
    final prompt = command.parameters.trim();
    if (prompt.isEmpty) return;

    // 1. Сначала переключаем вкладку на "ИИ Шеф" (RecipeGeneratorRoute)
    context.router.navigate(
      const MainNavigationRoute(
        children: [
          RecipeGeneratorRoute(),
        ],
      ),
    );

    // Показываем индикатор загрузки, пока идет генерация
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final generator = context.read<AiRecipeGeneratorService>();
      final generatedRecipe = await generator.generateRecipe(prompt);

      // Закрываем индикатор загрузки
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (generatedRecipe != null && context.mounted) {
        // 2. Открываем сгенерированное блюдо поверх таба "ИИ Шеф"
        context.router.push(GeneratedRecipePreviewRoute(
          recipe: generatedRecipe,
          prompt: prompt,
        ));
      }
    } catch (e) {
      // Закрываем индикатор загрузки
      if (context.mounted) {
        Navigator.pop(context);
      }
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка генерации'),
            content: const Text('Эта функция требует стабильного подключения к интернету. Проверьте соединение и попробуйте снова.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ОК'),
              )
            ],
          ),
        );
      }
    }
  }
}
