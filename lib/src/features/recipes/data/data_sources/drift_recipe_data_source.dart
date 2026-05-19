import 'dart:convert';
import 'package:smart_chef_ai_assistant/src/core/database/app_database.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';

class DriftRecipeDataSource {
  final AppDatabase _db;

  DriftRecipeDataSource(this._db);

  Future<List<Recipe>> getFavoriteRecipes() async {
    final rows = await _db.select(_db.favoriteRecipes).get();

    return rows.map((row) {
      final Map<String, dynamic> jsonMap = json.decode(row.recipeData);
      return Recipe.fromJson(jsonMap);
    }).toList();
  }

  Future<void> saveFavorite(Recipe recipe) async {
    final recipeJson = json.encode(recipe.toJson());

    await _db
        .into(_db.favoriteRecipes)
        .insertOnConflictUpdate(
          FavoriteRecipeEntry(id: recipe.id, recipeData: recipeJson),
        );
  }

  Future<void> removeFavorite(String recipeId) async {
    await (_db.delete(
      _db.favoriteRecipes,
    )..where((tbl) => tbl.id.equals(recipeId))).go();
  }

  // --- Custom Recipes ---
  Future<List<Recipe>> getCustomRecipes() async {
    final rows = await _db.select(_db.customRecipes).get();
    return rows.map((row) {
      final Map<String, dynamic> jsonMap = json.decode(row.recipeData);
      return Recipe.fromJson(jsonMap);
    }).toList();
  }

  Future<void> saveCustomRecipe(Recipe recipe) async {
    final recipeJson = json.encode(recipe.toJson());
    await _db
        .into(_db.customRecipes)
        .insertOnConflictUpdate(
          CustomRecipeEntry(id: recipe.id, recipeData: recipeJson),
        );
  }

  Future<void> deleteCustomRecipe(String recipeId) async {
    await (_db.delete(
      _db.customRecipes,
    )..where((tbl) => tbl.id.equals(recipeId))).go();
    
    // Also remove from favorites if it was favorited
    await removeFavorite(recipeId);
  }

  // --- Hidden Mock Recipes ---
  Future<List<String>> getHiddenRecipeIds() async {
    final rows = await _db.select(_db.hiddenRecipes).get();
    return rows.map((row) => row.id).toList();
  }

  Future<void> hideRecipe(String recipeId) async {
    await _db
        .into(_db.hiddenRecipes)
        .insertOnConflictUpdate(
          HiddenRecipeEntry(id: recipeId),
        );
    
    // Also remove from favorites if it was favorited
    await removeFavorite(recipeId);
  }
}
