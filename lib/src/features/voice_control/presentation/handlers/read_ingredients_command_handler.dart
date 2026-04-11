import 'dart:developer' as developer;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/core/services/tts_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/repositories/recipe_repository.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class ReadIngredientsCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) =>
      command.action == VoiceAction.readIngredients;

  @override
  void handle(BuildContext context, VoiceCommand command) async {
    final router = context.router;
    final topRoute = router.topRoute;

    if (topRoute.name != RecipeDetailRoute.name) {
      developer.log('Read ingredients failed: Not on RecipeDetail page', name: 'ReadIngredientsHandler');
      context.read<TtsService>().speak('Извините, чтобы прочитать ингредиенты, нужно открыть рецепт.');
      return;
    }

    final recipeId = topRoute.params.getString('recipeId');
    final repository = context.read<RecipeRepository>();
    
    try {
      final recipes = await repository.getRecipes();
      if (!context.mounted) return;
      
      final recipe = recipes.firstWhere((r) => r.id == recipeId);

      if (recipe.ingredients.isEmpty) {
        context.read<TtsService>().speak('В этом рецепте не указаны ингредиенты.');
        return;
      }

      String text = 'Для приготовления вам понадобятся: ';
      text += recipe.ingredients.join('. ');
      
      developer.log('Reading ingredients for recipe: $recipeId', name: 'ReadIngredientsHandler');
      context.read<TtsService>().speak(text);
    } catch (e) {
      developer.log('Error reading ingredients: $e', name: 'ReadIngredientsHandler');
    }
  }
}
