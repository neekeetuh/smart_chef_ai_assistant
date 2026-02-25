import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 'watch' нужен, чтобы Switch обновлялся
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: ListView(
        children: [
          // Переключение темы
          SwitchListTile(
            title: const Text(AppStrings.darkTheme),
            secondary: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            value: isDark,
            onChanged: (value) {
              // Используем 'read' внутри коллбэка
              context.read<ThemeProvider>().setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),

          // Заглушка для будущей фичи
          ListTile(
            title: const Text(AppStrings.voiceActivation),
            subtitle: const Text('Зажатие кнопки (по умолчанию)'),
            leading: const Icon(Icons.mic_none_outlined),
            onTap: () {
              // TODO: Показать диалог выбора (Шаг 3)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Эта функция будет добавлена позже'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
