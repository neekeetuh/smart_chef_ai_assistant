import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/global_voice_app_bar_action.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: const [GlobalVoiceAppBarAction()],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          final recipes = state.recipes;
          return state is RecipeLoadingState
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        // Навигация на детальный экран
                        context.router.push(
                          RecipeDetailRoute(recipeId: recipe.id),
                        );
                      },
                      onFavoriteTap: () {
                        // Вызываем метод провайдера (заглушка)
                        context.read<RecipeBloc>().add(
                          ToggleFavoriteEvent(recipe.id),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
