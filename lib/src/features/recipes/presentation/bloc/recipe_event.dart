part of 'recipe_bloc.dart'; // Обязательно, если используете part

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipesEvent extends RecipeEvent {
  const FetchRecipesEvent();
}

class ToggleFavoriteEvent extends RecipeEvent {
  final String recipeId;
  const ToggleFavoriteEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class SaveRecipeEvent extends RecipeEvent {
  final Recipe recipe;
  const SaveRecipeEvent(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String recipeId;
  const DeleteRecipeEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
