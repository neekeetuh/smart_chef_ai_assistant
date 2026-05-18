import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';
import 'package:smart_chef_ai_assistant/src/core/services/smart_classification_service.dart';
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
            final isWakeWord =
                (state is VoiceControlIdle && state.isWakeWordMode) ||
                state is VoiceControlWaitingForWakeWord ||
                state is VoiceControlWakeWordDetected ||
                state is VoiceControlListening;

            return SimpleDialog(
              title: const Text('Режим активации голоса'),
              children: [
                RadioGroup<bool>(
                  groupValue: isWakeWord,
                  onChanged: (value) {
                    if (value != null && value != isWakeWord) {
                      context.read<VoiceControlBloc>().add(
                        ToggleWakeWordEvent(),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Column(
                    children: [
                      RadioListTile<bool>(
                        title: Text('Зажатие кнопки (по умолчанию)'),
                        value: false,
                      ),
                      RadioListTile<bool>(
                        title: Text('Кодовое слово "Шеф" (Hands-free)'),
                        value: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClassificationModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final classificationService = context
            .watch<SmartClassificationService>();
        final currentMode = classificationService.currentMode;

        return SimpleDialog(
          title: const Text('Режим обработки команд'),
          children: [
            RadioGroup<ClassificationMode>(
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  classificationService.setClassificationMode(value);
                }
                Navigator.pop(context);
              },
              child: const Column(
                children: [
                  RadioListTile<ClassificationMode>(
                    title: Text('Локально на устройстве (Мгновенно)'),
                    subtitle: Text('Оффлайн-классификатор, работает за 1мс'),
                    value: ClassificationMode.onDevice,
                  ),
                  RadioListTile<ClassificationMode>(
                    title: Text('Облачная нейросеть (GigaChat)'),
                    subtitle: Text('Умный ИИ, требует интернет'),
                    value: ClassificationMode.llm,
                  ),
                ],
              ),
            ),
          ],
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

          // Выбор режима классификации
          Consumer<SmartClassificationService>(
            builder: (context, classificationService, child) {
              final mode = classificationService.currentMode;
              final modeText = mode == ClassificationMode.llm
                  ? 'Облачная нейросеть (GigaChat)'
                  : 'Локально на устройстве (Мгновенно)';

              return ListTile(
                title: const Text('Режим обработки команд'),
                subtitle: Text(modeText),
                leading: const Icon(Icons.psychology_outlined),
                onTap: () => _showClassificationModeDialog(context),
              );
            },
          ),
        ],
      ),
    );
  }
}
