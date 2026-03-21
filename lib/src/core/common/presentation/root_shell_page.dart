import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/voice_control_wrapper.dart';

@RoutePage()
class RootShellPage extends StatelessWidget {
  const RootShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    // В RootShellPage контекст уже "внутри" роутера, поэтому push будет работать
    return VoiceControlWrapper(
      child: const AutoRouter(),
    );
  }
}
