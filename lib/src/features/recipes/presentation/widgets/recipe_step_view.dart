import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/services/tts_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

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

  void _handleStepCommand(String param, {bool readAfter = false}) {
    final stepsCount = widget.recipe.steps.length;
    int? targetIndex;

    if (param == 'next') {
      if (_currentPage < stepsCount - 1) {
        targetIndex = _currentPage + 1;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (readAfter) {
        context.read<TtsService>().speak('Это последний шаг');
      }
    } else if (param == 'prev') {
      if (_currentPage > 0) {
        targetIndex = _currentPage - 1;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (readAfter) {
        context.read<TtsService>().speak('Это первый шаг');
      }
    } else if (param == 'current' && readAfter) {
      targetIndex = _currentPage;
      // В этом случае листать не надо, сразу озвучим
    } else {
      final stepNumber = int.tryParse(param);
      if (stepNumber != null) {
        final index = stepNumber - 1;
        if (index >= 0 && index < stepsCount) {
          targetIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (readAfter) {
          context.read<TtsService>().speak(
            'Шаг номер $stepNumber отсутствует в этом рецепте. Всего в нем ${widget.recipe.steps.length} шагов.',
          );
        }
      }
    }

    if (readAfter && targetIndex != null) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          final step = widget.recipe.steps[targetIndex!];
          context.read<TtsService>().speak(
            '${step.title}. ${step.description}',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipe.steps;
    return BlocListener<VoiceControlBloc, VoiceControlState>(
      listener: (context, state) {
        if (state is VoiceCommandRecognized) {
          if (state.command.action == VoiceAction.recipeStep) {
            _handleStepCommand(state.command.parameters);
          } else if (state.command.action == VoiceAction.readStep) {
            _handleStepCommand(state.command.parameters, readAfter: true);
          }
        }
      },
      child: Column(
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
      ),
    );
  }
}
