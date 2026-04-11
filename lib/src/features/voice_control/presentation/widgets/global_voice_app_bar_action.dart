import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';

class GlobalVoiceAppBarAction extends StatelessWidget {
  const GlobalVoiceAppBarAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceControlBloc, VoiceControlState>(
      builder: (context, state) {
        final isModeOn = (state is VoiceControlIdle && state.isWakeWordMode) ||
            state is VoiceControlWaitingForWakeWord ||
            state is VoiceControlWakeWordDetected ||
            state is VoiceControlListening ||
            state is VoiceControlProcessing ||
            state is VoiceCommandRecognized;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        Color? iconColor;
        if (state is VoiceControlWakeWordDetected || state is VoiceControlListening) {
          iconColor = Colors.redAccent;
        } else if (isModeOn) {
          iconColor = isDark ? Colors.green : Colors.white;
        } else {
          // Выключен - в светлой теме пусть будет белым, в темной стандартным
          iconColor = isDark ? null : Colors.white;
        }

        return IconButton(
          icon: Icon(
            isModeOn ? Icons.hearing : Icons.hearing_disabled,
            color: iconColor,
          ),
          onPressed: () {
            context.read<VoiceControlBloc>().add(ToggleWakeWordEvent());
          },
          tooltip: 'Режим "Шеф"',
        );
      },
    );
  }
}
