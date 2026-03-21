part of 'voice_control_bloc.dart';

abstract class VoiceControlState extends Equatable {
  const VoiceControlState();

  @override
  List<Object?> get props => [];
}

class VoiceControlIdle extends VoiceControlState {}

class VoiceControlListening extends VoiceControlState {}

class VoiceControlProcessing extends VoiceControlState {
  final String transcription;
  const VoiceControlProcessing(this.transcription);

  @override
  List<Object?> get props => [transcription];
}

class VoiceCommandRecognized extends VoiceControlState {
  final VoiceCommand command;
  const VoiceCommandRecognized(this.command);

  @override
  List<Object?> get props => [command];
}

class VoiceControlError extends VoiceControlState {
  final String message;
  const VoiceControlError(this.message);

  @override
  List<Object?> get props => [message];
}
