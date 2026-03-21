import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/widgets/recipe_step_view.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/global_voice_app_bar_action.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';

@RoutePage()
class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({
    super.key,
    @PathParam('recipeId') required this.recipeId,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSteps() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RecipeBloc>();
    final Recipe? recipe = bloc.getRecipeById(widget.recipeId);

    if (recipe == null) {
      return const Scaffold(body: Center(child: Text('Recipe not found')));
    }

    return BlocListener<VoiceControlBloc, VoiceControlState>(
      listener: (context, state) {
        if (state is VoiceCommandRecognized &&
            state.command.action == VoiceAction.recipeStep) {
          _scrollToSteps();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Аппбар с картинкой
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              title: Text(
                recipe.title,
                style: const TextStyle(
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withAlpha(75),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              actions: [
                const GlobalVoiceAppBarAction(),
                IconButton(
                  icon: Icon(
                    recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: recipe.isFavorite ? Colors.red[400] : Colors.white,
                  ),
                  onPressed: () {
                    bloc.add(ToggleFavoriteEvent(widget.recipeId));
                  },
                ),
              ],
            ),

            // Ингредиенты
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppStrings.ingredients,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    '• ${recipe.ingredients[index]}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }, childCount: recipe.ingredients.length),
            ),

            // Шаги (PageView)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppStrings.steps,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(child: RecipeStepView(recipe: recipe)),
          ],
        ),
      ),
    );
  }
}
