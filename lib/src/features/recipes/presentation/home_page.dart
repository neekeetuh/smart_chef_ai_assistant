import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/view_mode_provider.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_grid_card.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/global_voice_app_bar_action.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModeProvider = context.watch<ViewModeProvider>();
    final isGridView = viewModeProvider.isHomeGridView;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              viewModeProvider.toggleHomeViewMode();
            },
          ),
          const GlobalVoiceAppBarAction(),
        ],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          final recipes = state.recipes;
          if (state is RecipeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (isGridView) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeGridCard(
                  recipe: recipe,
                  onTap: () {
                    context.router.push(
                      RecipeDetailRoute(recipeId: recipe.id),
                    );
                  },
                  onFavoriteTap: () {
                    context.read<RecipeBloc>().add(
                          ToggleFavoriteEvent(recipe.id),
                        );
                  },
                );
              },
            );
          }

          return ListView.builder(
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
                  context.read<RecipeBloc>().add(
                        ToggleFavoriteEvent(recipe.id),
                      );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.router.push(RecipeEditRoute());
        },
      ),
    );
  }
}
