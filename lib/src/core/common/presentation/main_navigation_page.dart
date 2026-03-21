import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_chef_ai_assistant/src/core/common/presentation/widgets/core_navigation_bar.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/voice_command_processor.dart';

@RoutePage()
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final VoiceCommandProcessor _commandProcessor = VoiceCommandProcessor();

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [HomeRoute(), FavoritesRoute(), SettingsRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return BlocListener<VoiceControlBloc, VoiceControlState>(
          listener: (context, state) {
            if (state is VoiceCommandRecognized) {
              _commandProcessor.process(context, state.command);
              // recipe_step обрабатывается внутри RecipeStepView
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
              child: Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: CoreNavigationBar(
                  currentIndex: tabsRouter.activeIndex,
                  onTap: tabsRouter.setActiveIndex,
                ),
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

