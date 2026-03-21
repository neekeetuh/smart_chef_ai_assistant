part of 'voice_control_bloc.dart';

abstract class VoiceControlEvent extends Equatable {
  const VoiceControlEvent();

  @override
  List<Object?> get props => [];
}

class StartListeningEvent extends VoiceControlEvent {}

class StopListeningEvent extends VoiceControlEvent {}

class StartWakeWordEvent extends VoiceControlEvent {}

class ToggleWakeWordEvent extends VoiceControlEvent {}

class _WakeWordDetectedEvent extends VoiceControlEvent {}

class _SpeechRecognizedEvent extends VoiceControlEvent {
  final String text;
  final bool isFinal;
  const _SpeechRecognizedEvent(this.text, this.isFinal);

  @override
  List<Object?> get props => [text, isFinal];
}

class _SpeechErrorEvent extends VoiceControlEvent {
  final String error;
  const _SpeechErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}
