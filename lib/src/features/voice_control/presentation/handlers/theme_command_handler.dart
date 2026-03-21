import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class ThemeCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.theme;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    final themeProvider = context.read<ThemeProvider>();
    final param = command.parameters.toLowerCase();

    final themeMap = {
      'dark': ThemeMode.dark,
      'темная': ThemeMode.dark,
      'тёмная': ThemeMode.dark,
      'light': ThemeMode.light,
      'светлая': ThemeMode.light,
      'system': ThemeMode.system,
      'системная': ThemeMode.system,
    };

    for (final entry in themeMap.entries) {
      if (param.contains(entry.key)) {
        themeProvider.setThemeMode(entry.value);
        return;
      }
    }
  }
}
