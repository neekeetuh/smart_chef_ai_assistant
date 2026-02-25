import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_step_view.dart';

@RoutePage()
class RecipeDetailPage extends StatelessWidget {
  final String recipeId;

  const RecipeDetailPage({
    super.key,
    @PathParam('recipeId') required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RecipeBloc>();
    final Recipe recipe = bloc.getRecipeById(recipeId)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Аппбар с картинкой
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            title: Text(
              recipe.title,
              style: const TextStyle(
                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe.imageUrl,
                fit: .cover,
                // Добавляем затемнение для читаемости
                color: Colors.black.withAlpha(75),
                colorBlendMode: .darken,
              ),
            ),
            actions: [
              // Кнопка Избранное
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red[400] : Colors.white,
                ),
                onPressed: () {
                  bloc.add(ToggleFavoriteEvent(recipeId));
                },
              ),
            ],
          ),

          // Ингредиенты
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppStrings.ingredients,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Text(
                  '• ${recipe.ingredients[index]}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }, childCount: recipe.ingredients.length),
          ),

          // Шаги (PageView)
          SliverToBoxAdapter(
            child: Padding(
              padding: const .all(16.0),
              child: Text(
                AppStrings.steps,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          SliverToBoxAdapter(child: RecipeStepView(recipe: recipe)),
        ],
      ),
    );
  }
}
