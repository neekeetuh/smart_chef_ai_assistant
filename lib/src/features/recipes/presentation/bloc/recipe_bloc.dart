import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/data/repositories/recipe_repository.dart';

import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository _repository;

  RecipeBloc({required RecipeRepository repository})
    : _repository = repository,
      super(const RecipeState()) {
    // Регистрация обработчиков событий
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SaveRecipeEvent>(_onSaveRecipe);
    on<DeleteRecipeEvent>(_onDeleteRecipe);
  }

  Future<void> _onFetchRecipes(
    FetchRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoadingState());
    try {
      final recipes = await _repository.getRecipes();
      emit(RecipeSuccessfulState(recipes: recipes));
    } catch (e) {
      emit(
        RecipeErrorState(
          error: Exception('Ошибка загрузки рецептов: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    await _repository.toggleFavoriteStatus(event.recipeId);
    final updatedRecipes = await _repository.getRecipes();
    emit(RecipeSuccessfulState(recipes: updatedRecipes));
  }

  Future<void> _onSaveRecipe(
    SaveRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    await _repository.saveRecipe(event.recipe);
    final updatedRecipes = await _repository.getRecipes();
    emit(RecipeSuccessfulState(recipes: updatedRecipes));
  }

  Future<void> _onDeleteRecipe(
    DeleteRecipeEvent event,
    Emitter<RecipeState> emit,
  ) async {
    await _repository.deleteRecipe(event.recipeId);
    final updatedRecipes = await _repository.getRecipes();
    emit(RecipeSuccessfulState(recipes: updatedRecipes));
  }

  Recipe? getRecipeById(String id) {
    return _repository.getRecipeById(id);
  }
}
