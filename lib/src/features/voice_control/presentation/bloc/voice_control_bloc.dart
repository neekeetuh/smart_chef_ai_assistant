import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/voice_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/repositories/recipe_repository_interface.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'voice_control_event.dart';
part 'voice_control_state.dart';

class VoiceControlBloc extends Bloc<VoiceControlEvent, VoiceControlState> {
  final VoiceService _voiceService;
  final AiService _aiService;
  final RecipeRepositoryInterface _recipeRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _currentTranscription = '';
  bool _isFinalResultReceived = false;
  bool _isWakeWordMode = false;

  VoiceControlBloc({
    required VoiceService voiceService,
    required AiService aiService,
    required RecipeRepositoryInterface recipeRepository,
  }) : _voiceService = voiceService,
       _aiService = aiService,
       _recipeRepository = recipeRepository,
       super(const VoiceControlIdle()) {
    // Регистрация глобальных обработчиков событий STT
    _voiceService.init(
      onError: (err) {
        // Мы передаем сообщение об ошибке в блок для обработки перезапуска
        add(_SpeechErrorEvent(err.errorMsg));
      },
      onStatus: (status) {
        print('BLOC: STT Status: $status');
        if (status == 'done' && state is VoiceControlWaitingForWakeWord) {
          print(
            'BLOC: STT finished unexpectedly in Wake Word mode. Restarting...',
          );
          add(StartWakeWordEvent());
        }
      },
    );

    on<VoiceControlEvent>((event, emit) async {
      if (event is StartListeningEvent) {
        await _onStartListening(event, emit);
      } else if (event is StopListeningEvent) {
        await _onStopListening(event, emit);
      } else if (event is StartWakeWordEvent) {
        await _onStartWakeWord(event, emit);
      } else if (event is ToggleWakeWordEvent) {
        _onToggleWakeWord(event, emit);
      } else if (event is _WakeWordDetectedEvent) {
        await _onWakeWordDetected(event, emit);
      } else if (event is _SpeechRecognizedEvent) {
        await _onSpeechRecognized(event, emit);
      } else if (event is _SpeechErrorEvent) {
        await _onSpeechError(event, emit);
      }
    }, transformer: sequential());
  }

  void _onToggleWakeWord(
    ToggleWakeWordEvent event,
    Emitter<VoiceControlState> emit,
  ) {
    _isWakeWordMode = !_isWakeWordMode;
    print('BLOC: ToggleWakeWordMode is now $_isWakeWordMode');
    if (_isWakeWordMode) {
      add(StartWakeWordEvent());
    } else {
      _voiceService.stopListening();
      emit(const VoiceControlIdle(isWakeWordMode: false));
    }
  }

  Future<void> _onStartWakeWord(
    StartWakeWordEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    if (!_isWakeWordMode) return;
    emit(VoiceControlWaitingForWakeWord());
    await _voiceService.startWakeWordDetection(
      onDetected: () {
        add(_WakeWordDetectedEvent());
      },
    );
  }

  Future<void> _onWakeWordDetected(
    _WakeWordDetectedEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    print('BLOC: Wake Word Detected! Emitting detected state...');
    emit(VoiceControlWakeWordDetected());

    // Проигрываем короткий сигнал подтверждения
    _audioPlayer.play(AssetSource('sounds/beep.mp3'));

    // Увеличили задержку для повышения стабильности на некоторых устройствах
    await Future.delayed(const Duration(milliseconds: 400));

    print('BLOC: Starting command listen...');
    add(StartListeningEvent());
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
    if (state is! VoiceControlListening) {
      print(
        'BLOC: StopListeningEvent received but not in Listening state. Skipping.',
      );
      return;
    }

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
      emit(VoiceControlIdle(isWakeWordMode: _isWakeWordMode));
      if (_isWakeWordMode) add(StartWakeWordEvent());
      return;
    }

    print(
      'BLOC: Final processing transcription: "$_currentTranscription" (Final: $_isFinalResultReceived)',
    );
    emit(VoiceControlProcessing(_currentTranscription));

    try {
      final recipesList = await _recipeRepository.getRecipes();

      var command = await _aiService.classifyIntent(
        _currentTranscription,
        recipes: recipesList,
      );

      // Дополнительная проверка на валидность ID рецепта
      if (command.action == VoiceAction.openRecipe) {
        final exists = recipesList.any((r) => r.id == command.parameters);

        if (!exists ||
            command.parameters.contains('любой') ||
            command.parameters == 'random') {
          if (recipesList.isNotEmpty) {
            final randomRecipe = (recipesList..shuffle()).first;
            print(
              'BLOC: Recipe ID "${command.parameters}" not found or generic. Picking: ${randomRecipe.title}',
            );
            command = command.copyWith(parameters: randomRecipe.id);
          }
        }
      }

      print(
        'BLOC: Command recognized: ${command.action} with params ${command.parameters}',
      );
      emit(VoiceCommandRecognized(command));
    } catch (e) {
      print('BLOC ERROR GigaChat: $e');
      emit(VoiceControlError('Failed to process command: $e'));
    }

    // Возвращаемся в Idle после выполнения
    emit(VoiceControlIdle(isWakeWordMode: _isWakeWordMode));
    if (_isWakeWordMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      add(StartWakeWordEvent());
    }
  }

  Future<void> _onSpeechRecognized(
    _SpeechRecognizedEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    print('BLOC: Recognized: "${event.text}" (Final: ${event.isFinal})');
    _currentTranscription = event.text;
    _isFinalResultReceived = event.isFinal;

    if (event.isFinal && state is VoiceControlListening) {
      print('BLOC: Final result received. Triggering automatic stop/process.');
      add(StopListeningEvent());
    }
  }

  Future<void> _onSpeechError(
    _SpeechErrorEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    print('BLOC: Handling Speech Error: ${event.error}');

    // Игнорируем обычные таймауты и системные ошибки клиента для всплывашек
    final isIgnored =
        event.error.contains('error_no_match') ||
        event.error.contains('error_speech_timeout') ||
        event.error.contains('error_client');

    if (!isIgnored) {
      emit(VoiceControlError(event.error));
    }

    emit(VoiceControlIdle(isWakeWordMode: _isWakeWordMode));
    if (_isWakeWordMode) {
      print('BLOC: Restarting Wake Word after error...');
      await Future.delayed(const Duration(milliseconds: 500));
      add(StartWakeWordEvent());
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
