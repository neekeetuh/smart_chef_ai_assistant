import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_chef_ai_assistant/src/core/common/presentation/widgets/core_navigation_bar.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/core/providers/theme_provider.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';

@RoutePage()
class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [HomeRoute(), FavoritesRoute(), SettingsRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return BlocListener<VoiceControlBloc, VoiceControlState>(
          listener: (context, state) {
            if (state is VoiceCommandRecognized) {
              final cmd = state.command;

              if (cmd.action == VoiceAction.navigation) {
                if (cmd.parameters.contains('settings') ||
                    cmd.parameters.contains('настройки')) {
                  tabsRouter.setActiveIndex(2);
                } else if (cmd.parameters.contains('favorite') ||
                    cmd.parameters.contains('избранное')) {
                  tabsRouter.setActiveIndex(1);
                } else if (cmd.parameters.contains('home') ||
                    cmd.parameters.contains('главная')) {
                  tabsRouter.setActiveIndex(0);
                }
              } else if (cmd.action == VoiceAction.theme) {
                final themeProvider = context.read<ThemeProvider>();
                if (cmd.parameters.contains('dark') ||
                    cmd.parameters.contains('тёмная') ||
                    cmd.parameters.contains('темная')) {
                  themeProvider.setThemeMode(ThemeMode.dark);
                } else if (cmd.parameters.contains('light') ||
                    cmd.parameters.contains('светлая')) {
                  themeProvider.setThemeMode(ThemeMode.light);
                } else if (cmd.parameters.contains('system') ||
                    cmd.parameters.contains('системная')) {
                  themeProvider.setThemeMode(ThemeMode.system);
                }
              }
              // recipe_step обрабатывается внутри RecipeStepView
            } else if (state is VoiceControlListening) {
              // Snackbar удален, чтобы не смещать FAB
            } else if (state is VoiceControlProcessing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Обработка команды: "${state.transcription}"...',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is VoiceControlError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: ${state.message}')),
              );
            }
          },
          child: Scaffold(
            // 1. Постоянная кнопка в центре
            floatingActionButton: GestureDetector(
              onLongPressStart: (_) {
                context.read<VoiceControlBloc>().add(StartListeningEvent());
              },
              onLongPressEnd: (_) {
                context.read<VoiceControlBloc>().add(StopListeningEvent());
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Нажмите и удерживайте для голосового управления',
                        ),
                      ),
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: BlocBuilder<VoiceControlBloc, VoiceControlState>(
                    builder: (context, state) {
                      return Icon(
                        state is VoiceControlListening
                            ? Icons.mic
                            : Icons.mic_none,
                        color: state is VoiceControlListening
                            ? Colors.redAccent
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),

            // 2. Расположение FAB по центру
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // 3. Нижний бар с вырезом
            bottomNavigationBar: BottomAppBar(
              height: 100,
              padding: const EdgeInsets.only(bottom: 10),
              shape: const CircularNotchedRectangle(), // Вырез для FAB
              notchMargin: 6.0,
              child: const Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: CoreNavigationBar(),
              ),
            ),

            // Основной контент
            body: child,
          ),
        );
      },
    );
  }
}
