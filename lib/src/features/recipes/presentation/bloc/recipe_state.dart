part of 'recipe_bloc.dart';

class RecipeState {
  final List<Recipe> recipes;

  const RecipeState({this.recipes = const []});

  // Геттер для удобства
  List<Recipe> get favoriteRecipes =>
      recipes.where((r) => r.isFavorite).toList();

  RecipeState copyWith({List<Recipe>? recipes}) {
    return RecipeState(recipes: recipes ?? this.recipes);
  }
}

class RecipeLoadingState extends RecipeState {
  const RecipeLoadingState({super.recipes});
}

class RecipeErrorState extends RecipeState {
  final Object error;

  const RecipeErrorState({super.recipes, required this.error});
}

class RecipeSuccessfulState extends RecipeState {
  const RecipeSuccessfulState({super.recipes});
}
