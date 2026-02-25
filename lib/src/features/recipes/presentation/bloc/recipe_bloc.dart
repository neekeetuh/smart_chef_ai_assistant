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

  // === Метод, заменяющий toggleFavorite() ===
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<RecipeState> emit,
  ) async {
    // 1. Изменяем статус в репозитории (внутреннем кэше)
    await _repository.toggleFavoriteStatus(event.recipeId);

    // 2. Получаем обновленный список из репозитория
    final updatedRecipes = await _repository.getRecipes();

    // 3. Обновляем состояние BLoC
    emit(RecipeSuccessfulState(recipes: updatedRecipes));
  }

  // === Метод, заменяющий getRecipeById() (должен работать с реализованным репозиторием) ===
  Recipe? getRecipeById(String id) {
    return _repository.getRecipeById(id);
  }
}
