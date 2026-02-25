import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';

class RecipeStepView extends StatefulWidget {
  final Recipe recipe;
  const RecipeStepView({super.key, required this.recipe});

  @override
  State<RecipeStepView> createState() => _RecipeStepViewState();
}

class _RecipeStepViewState extends State<RecipeStepView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipe.steps;
    return Column(
      children: [
        // PageView для шагов
        SizedBox(
          height: 300, // Задаем высоту
          child: PageView.builder(
            controller: _pageController,
            itemCount: steps.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final step = steps[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface.withAlpha(128),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 24),
                        Expanded(
                          child: Text(
                            step.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Индикатор страниц
        if (steps.length > 1)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 10.0,
                  width: _currentPage == index ? 24.0 : 10.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
