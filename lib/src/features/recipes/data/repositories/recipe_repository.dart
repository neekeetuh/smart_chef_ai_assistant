import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/mock_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/data_sources/drift_recipe_data_source.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/repositories/recipe_repository_interface.dart';

class RecipeRepository implements RecipeRepositoryInterface {
  final MockRecipeDataSource _mockDataSource;
  final DriftRecipeDataSource _driftDataSource;

  List<Recipe> _recipes = [];

  RecipeRepository({
    required MockRecipeDataSource mockDataSource,
    required DriftRecipeDataSource driftDataSource,
  }) : _mockDataSource = mockDataSource,
       _driftDataSource = driftDataSource;

  @override
  Future<List<Recipe>> getRecipes() async {
    if (_recipes.isEmpty) {
      final mockRecipes = await _mockDataSource.getAllRecipes();
      final favorites = await _driftDataSource.getFavoriteRecipes();

      final favoriteIds = favorites.map((e) => e.id).toSet();

      _recipes = mockRecipes.map((r) {
        if (favoriteIds.contains(r.id)) {
          return r.copyWith(isFavorite: true);
        }
        return r;
      }).toList();
    }
    return _recipes;
  }

  @override
  Future<void> toggleFavoriteStatus(String recipeId) async {
    final index = _recipes.indexWhere((r) => r.id == recipeId);

    if (index != -1) {
      final recipe = _recipes[index];
      final toggledRecipe = recipe.copyWith(isFavorite: !recipe.isFavorite);

      _recipes[index] = toggledRecipe;

      if (toggledRecipe.isFavorite) {
        await _driftDataSource.saveFavorite(toggledRecipe);
      } else {
        await _driftDataSource.removeFavorite(toggledRecipe.id);
      }
    }
  }

  Recipe? getRecipeById(String id) {
    final results = _recipes.where((r) => r.id == id);
    return results.isEmpty ? null : results.first;
  }
}
