import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/bloc/voice_control_bloc.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/voice_command_processor.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/presentation/widgets/voice_help_bottom_sheet.dart';

class VoiceControlWrapper extends StatefulWidget {
  final Widget child;
  const VoiceControlWrapper({super.key, required this.child});

  @override
  State<VoiceControlWrapper> createState() => _VoiceControlWrapperState();
}

class _VoiceControlWrapperState extends State<VoiceControlWrapper> {
  final VoiceCommandProcessor _commandProcessor = VoiceCommandProcessor();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceControlBloc, VoiceControlState>(
      listener: (context, state) {
        if (state is VoiceCommandRecognized) {
          final handled = _commandProcessor.process(context, state.command);
          if (!handled) {
            VoiceHelpBottomSheet.show(context);
          }
        } else if (state is VoiceControlProcessing) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Обработка: "${state.transcription}"'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is VoiceControlError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: widget.child,
    );
  }
}
