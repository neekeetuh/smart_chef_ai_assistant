import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/voice_service.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

// --- Events ---
abstract class VoiceControlEvent extends Equatable {
  const VoiceControlEvent();

  @override
  List<Object?> get props => [];
}

class StartListeningEvent extends VoiceControlEvent {}

class StopListeningEvent extends VoiceControlEvent {}

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

// --- States ---
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

// --- BLoC ---
class VoiceControlBloc extends Bloc<VoiceControlEvent, VoiceControlState> {
  final VoiceService _voiceService;
  final AiService _aiService;

  String _currentTranscription = '';
  bool _isFinalResultReceived = false;

  VoiceControlBloc({
    required VoiceService voiceService,
    required AiService aiService,
  }) : _voiceService = voiceService,
       _aiService = aiService,
       super(VoiceControlIdle()) {
    on<VoiceControlEvent>((event, emit) async {
      if (event is StartListeningEvent) {
        await _onStartListening(event, emit);
      } else if (event is StopListeningEvent) {
        await _onStopListening(event, emit);
      } else if (event is _SpeechRecognizedEvent) {
        _onSpeechRecognized(event, emit);
      } else if (event is _SpeechErrorEvent) {
        _onSpeechError(event, emit);
      }
    }, transformer: sequential());
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    print('BLOC: StartListeningEvent');
    _currentTranscription = '';
    _isFinalResultReceived = false;
    emit(VoiceControlListening());

    try {
      await _voiceService.startListening(
        onResult: (text, isFinal) {
          print('BLOC CALLBACK: text="$text", isFinal=$isFinal');
          _currentTranscription = text;
          _isFinalResultReceived = isFinal;
          add(_SpeechRecognizedEvent(text, isFinal));
        },
      );
    } catch (e) {
      add(_SpeechErrorEvent(e.toString()));
    }
  }

  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    print('BLOC: StopListeningEvent. Requesting stop...');
    await _voiceService.stopListening();

    // Ждем, пока плагин выдаст ФИНАЛЬНЫЙ результат.
    int retry = 0;
    while (!_isFinalResultReceived && retry < 15) {
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }

    if (_currentTranscription.isEmpty) {
      print('BLOC: Transcription is EMPTY after waiting. Returning to Idle.');
      emit(VoiceControlIdle());
      return;
    }

    print(
      'BLOC: Final processing transcription: "$_currentTranscription" (Final: $_isFinalResultReceived)',
    );
    emit(VoiceControlProcessing(_currentTranscription));

    try {
      final command = await _aiService.classifyIntent(_currentTranscription);
      print(
        'BLOC: Command recognized: ${command.action} with params ${command.parameters}',
      );
      emit(VoiceCommandRecognized(command));
    } catch (e) {
      print('BLOC ERROR GigaChat: $e');
      emit(VoiceControlError('Failed to process command: $e'));
    }

    // Возвращаемся в Idle после выполнения
    emit(VoiceControlIdle());
  }

  void _onSpeechRecognized(
    _SpeechRecognizedEvent event,
    Emitter<VoiceControlState> emit,
  ) {
    print('BLOC: Recognized: "${event.text}" (Final: ${event.isFinal})');
    _currentTranscription = event.text;
    _isFinalResultReceived = event.isFinal;
  }

  void _onSpeechError(
    _SpeechErrorEvent event,
    Emitter<VoiceControlState> emit,
  ) {
    emit(VoiceControlError(event.error));
    emit(VoiceControlIdle());
  }
}
