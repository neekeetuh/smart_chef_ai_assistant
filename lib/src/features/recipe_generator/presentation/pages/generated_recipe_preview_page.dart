import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipe_generator/data/services/ai_recipe_generator_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';

@RoutePage()
class GeneratedRecipePreviewPage extends StatefulWidget {
  final Recipe recipe;
  final String prompt;

  const GeneratedRecipePreviewPage({super.key, required this.recipe, required this.prompt});

  @override
  State<GeneratedRecipePreviewPage> createState() => _GeneratedRecipePreviewPageState();
}

class _GeneratedRecipePreviewPageState extends State<GeneratedRecipePreviewPage> {
  bool _isLoading = false;

  void _saveRecipe() async {
    context.read<RecipeBloc>().add(SaveRecipeEvent(widget.recipe));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Рецепт успешно сохранен!')),
    );

    // Задержка в 500 мс, чтобы рецепт гарантированно записался в БД
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // 1. Переходим на главную вкладку "Рецепты"
      context.router.navigate(
        MainNavigationRoute(
          children: [
            const HomeRoute(),
          ],
        ),
      );

      // 2. Открываем страницу с деталями рецепта поверх главной вкладки
      context.router.push(RecipeDetailRoute(recipeId: widget.recipe.id));
    }
  }

  Future<void> _regenerate() async {
    setState(() => _isLoading = true);
    try {
      final generator = context.read<AiRecipeGeneratorService>();
      final newRecipe = await generator.generateRecipe(widget.prompt);
      
      setState(() => _isLoading = false);
      
      if (newRecipe != null && mounted) {
        context.router.replace(GeneratedRecipePreviewRoute(
          recipe: newRecipe,
          prompt: widget.prompt,
        ));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка генерации'),
            content: const Text('Не удалось перегенерировать рецепт. Проверьте подключение к интернету.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ОК'),
              )
            ],
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сгенерированный рецепт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Сохранить рецепт',
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Кнопка регенерации
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _regenerate,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Сгенерировать другой вариант'),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text('Ингредиенты', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...widget.recipe.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 10),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ing, style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                  Text('Шаги приготовления', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...widget.recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Шаг ${index + 1}: ${step.title}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(step.description, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
