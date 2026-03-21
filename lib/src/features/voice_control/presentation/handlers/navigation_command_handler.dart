import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';

class NavigationCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.navigation;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    final param = command.parameters.toLowerCase();
    
    // Определяем на какой дочерний роут внутри MainNavigation мы хотим попасть
    PageRouteInfo? targetSubRoute;

    if (param.contains('settings') || param.contains('настройки')) {
      targetSubRoute = const SettingsRoute();
    } else if (param.contains('favorite') || param.contains('favorites') || param.contains('избранное')) {
      targetSubRoute = const FavoritesRoute();
    } else if (param.contains('home') || param.contains('главная') || param.contains('main')) {
      targetSubRoute = const HomeRoute();
    }

    if (targetSubRoute != null) {
      // Используем navigate вместо setActiveIndex, чтобы сработало из любого места дерева
      // (например, при переходе с экрана деталей обратно в табы)
      context.router.navigate(
        MainNavigationRoute(children: [targetSubRoute]),
      );
    }
  }
}
