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
