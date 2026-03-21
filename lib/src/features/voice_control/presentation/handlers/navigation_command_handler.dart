import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class NavigationCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.navigation;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    final tabsRouter = AutoTabsRouter.of(context);
    final param = command.parameters.toLowerCase();
    
    // We can use a map instead of if-else sequence for cleaner look
    final routeMap = {
      'settings': 2,
      'настройки': 2,
      'favorite': 1,
      'favorites': 1,
      'избранное': 1,
      'home': 0,
      'главная': 0,
      'main': 0,
    };

    for (final entry in routeMap.entries) {
      if (param.contains(entry.key)) {
        tabsRouter.setActiveIndex(entry.value);
        return;
      }
    }
  }
}
