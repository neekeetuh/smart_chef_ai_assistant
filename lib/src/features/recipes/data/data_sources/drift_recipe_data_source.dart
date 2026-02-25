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
}
