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
