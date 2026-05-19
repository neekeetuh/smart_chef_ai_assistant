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
    final mockRecipes = await _mockDataSource.getAllRecipes();
    final customRecipes = await _driftDataSource.getCustomRecipes();
    final hiddenRecipeIds = await _driftDataSource.getHiddenRecipeIds();
    final favorites = await _driftDataSource.getFavoriteRecipes();

    final favoriteIds = favorites.map((e) => e.id).toSet();
    final customRecipeIds = customRecipes.map((c) => c.id).toSet();
    final hiddenIds = hiddenRecipeIds.toSet();

    final visibleMockRecipes = mockRecipes.where((r) => 
        !hiddenIds.contains(r.id) && !customRecipeIds.contains(r.id)
    ).toList();
    
    final allRecipes = [...customRecipes, ...visibleMockRecipes];

    // Сортируем по дате изменения: сначала новые (dateB.compareTo(dateA))
    allRecipes.sort((a, b) {
      final dateA = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    _recipes = allRecipes.map((r) {
      if (favoriteIds.contains(r.id)) {
        return r.copyWith(isFavorite: true);
      }
      return r.copyWith(isFavorite: false);
    }).toList();

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

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    await _driftDataSource.saveCustomRecipe(recipe);
    // Reload recipes
    await getRecipes();
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    final isCustom = (await _driftDataSource.getCustomRecipes()).any((r) => r.id == recipeId);
    if (isCustom) {
      await _driftDataSource.deleteCustomRecipe(recipeId);
    }
    // Always hide the recipe ID to prevent a base mock recipe from reappearing
    // if the deleted custom recipe was originally an edited base recipe.
    await _driftDataSource.hideRecipe(recipeId);
    
    // Reload recipes
    await getRecipes();
  }

  Recipe? getRecipeById(String id) {
    final results = _recipes.where((r) => r.id == id);
    return results.isEmpty ? null : results.first;
  }
}
