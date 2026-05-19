// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [FavoritesPage]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute({List<PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesPage();
    },
  );
}

/// generated route for
/// [GeneratedRecipePreviewPage]
class GeneratedRecipePreviewRoute
    extends PageRouteInfo<GeneratedRecipePreviewRouteArgs> {
  GeneratedRecipePreviewRoute({
    Key? key,
    required Recipe recipe,
    required String prompt,
    List<PageRouteInfo>? children,
  }) : super(
         GeneratedRecipePreviewRoute.name,
         args: GeneratedRecipePreviewRouteArgs(
           key: key,
           recipe: recipe,
           prompt: prompt,
         ),
         initialChildren: children,
       );

  static const String name = 'GeneratedRecipePreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GeneratedRecipePreviewRouteArgs>();
      return GeneratedRecipePreviewPage(
        key: args.key,
        recipe: args.recipe,
        prompt: args.prompt,
      );
    },
  );
}

class GeneratedRecipePreviewRouteArgs {
  const GeneratedRecipePreviewRouteArgs({
    this.key,
    required this.recipe,
    required this.prompt,
  });

  final Key? key;

  final Recipe recipe;

  final String prompt;

  @override
  String toString() {
    return 'GeneratedRecipePreviewRouteArgs{key: $key, recipe: $recipe, prompt: $prompt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GeneratedRecipePreviewRouteArgs) return false;
    return key == other.key && recipe == other.recipe && prompt == other.prompt;
  }

  @override
  int get hashCode => key.hashCode ^ recipe.hashCode ^ prompt.hashCode;
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [MainNavigationPage]
class MainNavigationRoute extends PageRouteInfo<void> {
  const MainNavigationRoute({List<PageRouteInfo>? children})
    : super(MainNavigationRoute.name, initialChildren: children);

  static const String name = 'MainNavigationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainNavigationPage();
    },
  );
}

/// generated route for
/// [RecipeDetailPage]
class RecipeDetailRoute extends PageRouteInfo<RecipeDetailRouteArgs> {
  RecipeDetailRoute({
    Key? key,
    required String recipeId,
    List<PageRouteInfo>? children,
  }) : super(
         RecipeDetailRoute.name,
         args: RecipeDetailRouteArgs(key: key, recipeId: recipeId),
         rawPathParams: {'recipeId': recipeId},
         initialChildren: children,
       );

  static const String name = 'RecipeDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RecipeDetailRouteArgs>(
        orElse: () =>
            RecipeDetailRouteArgs(recipeId: pathParams.getString('recipeId')),
      );
      return RecipeDetailPage(key: args.key, recipeId: args.recipeId);
    },
  );
}

class RecipeDetailRouteArgs {
  const RecipeDetailRouteArgs({this.key, required this.recipeId});

  final Key? key;

  final String recipeId;

  @override
  String toString() {
    return 'RecipeDetailRouteArgs{key: $key, recipeId: $recipeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RecipeDetailRouteArgs) return false;
    return key == other.key && recipeId == other.recipeId;
  }

  @override
  int get hashCode => key.hashCode ^ recipeId.hashCode;
}

/// generated route for
/// [RecipeEditPage]
class RecipeEditRoute extends PageRouteInfo<RecipeEditRouteArgs> {
  RecipeEditRoute({Key? key, Recipe? recipe, List<PageRouteInfo>? children})
    : super(
        RecipeEditRoute.name,
        args: RecipeEditRouteArgs(key: key, recipe: recipe),
        initialChildren: children,
      );

  static const String name = 'RecipeEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecipeEditRouteArgs>(
        orElse: () => const RecipeEditRouteArgs(),
      );
      return RecipeEditPage(key: args.key, recipe: args.recipe);
    },
  );
}

class RecipeEditRouteArgs {
  const RecipeEditRouteArgs({this.key, this.recipe});

  final Key? key;

  final Recipe? recipe;

  @override
  String toString() {
    return 'RecipeEditRouteArgs{key: $key, recipe: $recipe}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RecipeEditRouteArgs) return false;
    return key == other.key && recipe == other.recipe;
  }

  @override
  int get hashCode => key.hashCode ^ recipe.hashCode;
}

/// generated route for
/// [RecipeGeneratorPage]
class RecipeGeneratorRoute extends PageRouteInfo<void> {
  const RecipeGeneratorRoute({List<PageRouteInfo>? children})
    : super(RecipeGeneratorRoute.name, initialChildren: children);

  static const String name = 'RecipeGeneratorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecipeGeneratorPage();
    },
  );
}

/// generated route for
/// [RootShellPage]
class RootShellRoute extends PageRouteInfo<void> {
  const RootShellRoute({List<PageRouteInfo>? children})
    : super(RootShellRoute.name, initialChildren: children);

  static const String name = 'RootShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RootShellPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}
