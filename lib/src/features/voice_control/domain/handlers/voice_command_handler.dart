import 'package:flutter/widgets.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

abstract class VoiceCommandHandler {
  bool canHandle(VoiceCommand command);
  void handle(BuildContext context, VoiceCommand command);
}
