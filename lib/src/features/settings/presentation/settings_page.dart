import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';

import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/global_voice_app_bar_action.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showActivationModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<VoiceControlBloc, VoiceControlState>(
          builder: (context, state) {
            final isWakeWord = (state is VoiceControlIdle && state.isWakeWordMode) ||
                state is VoiceControlWaitingForWakeWord ||
                state is VoiceControlWakeWordDetected ||
                state is VoiceControlListening;

            return SimpleDialog(
              title: const Text('Режим активации голоса'),
              children: [
                RadioListTile<bool>(
                  title: const Text('Зажатие кнопки (по умолчанию)'),
                  value: false,
                  groupValue: isWakeWord,
                  onChanged: (value) {
                    if (isWakeWord) {
                      context.read<VoiceControlBloc>().add(ToggleWakeWordEvent());
                    }
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<bool>(
                  title: const Text('Кодовое слово "Шеф" (Hands-free)'),
                  value: true,
                  groupValue: isWakeWord,
                  onChanged: (value) {
                    if (!isWakeWord) {
                      context.read<VoiceControlBloc>().add(ToggleWakeWordEvent());
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
        actions: const [GlobalVoiceAppBarAction()],
      ),
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
              context.read<ThemeProvider>().setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),

          // Выбор режима голоса
          BlocBuilder<VoiceControlBloc, VoiceControlState>(
            builder: (context, state) {
              final isWakeWord =
                  (state is VoiceControlIdle && state.isWakeWordMode) ||
                  state is VoiceControlWaitingForWakeWord ||
                  state is VoiceControlWakeWordDetected ||
                  state is VoiceControlListening;

              return ListTile(
                title: const Text(AppStrings.voiceActivation),
                subtitle: Text(
                  isWakeWord ? 'Кодовое слово "Шеф"' : 'Зажатие кнопки',
                ),
                leading: const Icon(Icons.mic_none_outlined),
                onTap: () => _showActivationModeDialog(context),
              );
            },
          ),
        ],
      ),
    );
  }
}
