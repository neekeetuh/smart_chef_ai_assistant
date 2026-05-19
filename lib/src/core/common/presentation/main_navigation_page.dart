import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/common/presentation/widgets/core_navigation_bar.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';

@RoutePage()
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [HomeRoute(), FavoritesRoute(), RecipeGeneratorRoute(), SettingsRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          // Аппбар убран из шелла, чтобы не было дублей на страницах
          floatingActionButton: BlocBuilder<VoiceControlBloc, VoiceControlState>(
            builder: (context, state) {
              final isWakeWordActive =
                  (state is VoiceControlIdle && state.isWakeWordMode) ||
                  state is VoiceControlWaitingForWakeWord ||
                  state is VoiceControlWakeWordDetected ||
                  state is VoiceControlListening;

              if (isWakeWordActive) return const SizedBox.shrink();

              return GestureDetector(
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
                    child: const Icon(Icons.mic_none),
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            height: 100,
            padding: const EdgeInsets.only(bottom: 10),
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: CoreNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
