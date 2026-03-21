import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/global_voice_app_bar_action.dart';

@RoutePage()
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favoritesTitle),
        actions: const [GlobalVoiceAppBarAction()],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          final favoriteRecipes = state.favoriteRecipes;
          return favoriteRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'Вы еще не добавили рецепты в избранное',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = favoriteRecipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        context.router.push(
                          RecipeDetailRoute(recipeId: recipe.id),
                        );
                      },
                      onFavoriteTap: () {
                        // Удаляем из избранного
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
