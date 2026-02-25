import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';

abstract interface class RecipeRepositoryInterface {
  Future<List<Recipe>> getRecipes();
  Future<void> toggleFavoriteStatus(String recipeId);
  // Future<Recipe> getRecipeDetails(String recipeId); // Для будущей оптимизации
}
