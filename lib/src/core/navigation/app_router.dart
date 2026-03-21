import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/core/common/presentation/main_navigation_page.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/favorites_page.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/home_page.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/recipe_detail_page.dart';
import 'package:smart_chef_ai_assistant/src/features/settings/presentation/settings_page.dart';

import 'package:smart_chef_ai_assistant/src/core/common/presentation/root_shell_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Родительский шелл для всего приложения (сюда входит глобальный VoiceControl)
    AutoRoute(
      page: RootShellRoute.page,
      initial: true,
      path: '/',
      children: [
        // Главный экран с нижним баром
        AutoRoute(
          page: MainNavigationRoute.page,
          initial: true,
          path: '', // Пустой путь, т.к. это первый ребенок
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home'),
            AutoRoute(page: FavoritesRoute.page, path: 'favorites'),
            AutoRoute(page: SettingsRoute.page, path: 'settings'),
          ],
        ),
        // Экран Деталей теперь соседний в RootShell, открывается "поверх" MainNavigation
        AutoRoute(page: RecipeDetailRoute.page, path: 'recipe/:recipeId'),
      ],
    ),
  ];
}
