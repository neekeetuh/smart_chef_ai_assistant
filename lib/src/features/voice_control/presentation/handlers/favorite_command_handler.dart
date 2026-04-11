import 'dart:developer' as developer;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class FavoriteCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.favorite;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    String? recipeId;
    final router = context.router;

    if (command.parameters == 'current') {
      // Ищем ID текущего рецепта через самый верхний активный маршрут
      final topRoute = router.topRoute;
      developer.log('Current top route: ${topRoute.name}', name: 'FavoriteCommandHandler');
      
      if (topRoute.name == RecipeDetailRoute.name) {
        recipeId = topRoute.pathParams.getString('recipeId');
        developer.log('Contextual ID found: $recipeId', name: 'FavoriteCommandHandler');
      } else {
        developer.log('Not on RecipeDetailRoute.', name: 'FavoriteCommandHandler');
      }
    } else if (command.parameters.isNotEmpty) {
      // Использовать ID предоставленный в параметрах (из GigaChat)
      recipeId = command.parameters;
    }

    if (recipeId != null) {
      context.read<RecipeBloc>().add(ToggleFavoriteEvent(recipeId));
    }
  }
}
