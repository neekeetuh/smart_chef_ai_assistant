import 'dart:async';
import 'dart:developer' as developer;
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/voice_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/tts_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/repositories/recipe_repository_interface.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

part 'voice_control_event.dart';
part 'voice_control_state.dart';

class VoiceControlBloc extends Bloc<VoiceControlEvent, VoiceControlState> {
  final VoiceService _voiceService;
  final AiService _aiService;
  final TtsService _ttsService;
  final RecipeRepositoryInterface _recipeRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _currentTranscription = '';
  bool _isFinalResultReceived = false;
  bool _isWakeWordMode = false;
  Timer? _restartTimer;

  VoiceControlBloc({
    required VoiceService voiceService,
    required AiService aiService,
    required TtsService ttsService,
    required RecipeRepositoryInterface recipeRepository,
  }) : _voiceService = voiceService,
       _aiService = aiService,
       _ttsService = ttsService,
       _recipeRepository = recipeRepository,
       super(const VoiceControlIdle()) {
    // Регистрация глобальных обработчиков событий STT
    _voiceService.init(
      onError: (err) {
        add(_SpeechErrorEvent(err.errorMsg));
      },
      onStatus: (status) {
        developer.log('STT Status: $status', name: 'VoiceControlBloc');

        // Перезапускаем только если мы в режиме прослушивания ключевого слова
        // и сессия закончилась (status == 'done' или 'notListening')
        if ((status == 'done' || status == 'notListening') && _isWakeWordMode) {
          // Проверяем, что мы не находимся в процессе записи РЕАЛЬНОЙ команды
          // (когда state — VoiceControlListening или VoiceControlProcessing)
          final canRestart =
              state is VoiceControlWaitingForWakeWord ||
              state is VoiceControlIdle ||
              state is VoiceControlError;

          if (canRestart) {
            _cancelRestartTimer();
            _restartTimer = Timer(const Duration(milliseconds: 300), () {
              if (_isWakeWordMode &&
                  (state is VoiceControlWaitingForWakeWord ||
                      state is VoiceControlIdle ||
                      state is VoiceControlError)) {
                add(StartWakeWordEvent());
              }
            });
          }
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
    _cancelRestartTimer();
    _isWakeWordMode = !_isWakeWordMode;
    developer.log(
      'ToggleWakeWordMode is now $_isWakeWordMode',
      name: 'VoiceControlBloc',
    );
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
    _cancelRestartTimer();
    developer.log(
      'Wake Word Detected! Emitting detected state...',
      name: 'VoiceControlBloc',
    );
    emit(VoiceControlWakeWordDetected());

    _audioPlayer.play(AssetSource('sounds/beep.mp3'));

    await Future.delayed(const Duration(milliseconds: 800));

    developer.log('Starting command listen...', name: 'VoiceControlBloc');
    add(StartListeningEvent());
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    _cancelRestartTimer();
    developer.log('StartListeningEvent', name: 'VoiceControlBloc');

    // Останавливаем любую текущую озвучку перед началом записи
    await _ttsService.stop();

    _currentTranscription = '';
    _isFinalResultReceived = false;
    emit(VoiceControlListening());

    try {
      await _voiceService.startListening(
        onResult: (text, isFinal) {
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
    if (state is! VoiceControlListening) return;

    developer.log(
      'StopListeningEvent. Requesting stop...',
      name: 'VoiceControlBloc',
    );
    await _voiceService.stopListening();

    int retry = 0;
    while (!_isFinalResultReceived && retry < 15) {
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }

    if (_currentTranscription.isEmpty) {
      emit(VoiceControlIdle(isWakeWordMode: _isWakeWordMode));
      if (_isWakeWordMode) add(StartWakeWordEvent());
      return;
    }

    developer.log(
      'Final processing transcription: "$_currentTranscription"',
      name: 'VoiceControlBloc',
    );
    emit(VoiceControlProcessing(_currentTranscription));

    try {
      final recipesList = await _recipeRepository.getRecipes();

      var command = await _aiService.classifyIntent(
        _currentTranscription,
        recipes: recipesList,
      );

      if (command.action == VoiceAction.openRecipe) {
        final exists = recipesList.any((r) => r.id == command.parameters);
        if (!exists ||
            command.parameters.contains('любой') ||
            command.parameters == 'random') {
          if (recipesList.isNotEmpty) {
            final randomRecipe = (recipesList..shuffle()).first;
            command = command.copyWith(parameters: randomRecipe.id);
          }
        }
      }

      developer.log(
        'Command recognized: ${command.action}',
        name: 'VoiceControlBloc',
      );
      emit(VoiceCommandRecognized(command));
    } catch (e) {
      developer.log('ERROR GigaChat: $e', name: 'VoiceControlBloc', error: e);
      emit(VoiceControlError('Failed to process command: $e'));
    }

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
    _currentTranscription = event.text;
    _isFinalResultReceived = event.isFinal;

    if (event.isFinal && state is VoiceControlListening) {
      add(StopListeningEvent());
    }
  }

  Future<void> _onSpeechError(
    _SpeechErrorEvent event,
    Emitter<VoiceControlState> emit,
  ) async {
    developer.log(
      'Handling Speech Error: ${event.error}',
      name: 'VoiceControlBloc',
    );

    final isIgnored =
        event.error.contains('error_no_match') ||
        event.error.contains('error_speech_timeout') ||
        event.error.contains('error_client');

    if (!isIgnored) {
      emit(VoiceControlError(event.error));
    }

    emit(VoiceControlIdle(isWakeWordMode: _isWakeWordMode));

    if (_isWakeWordMode) {
      _cancelRestartTimer();
      _restartTimer = Timer(const Duration(milliseconds: 300), () {
        if (_isWakeWordMode &&
            (state is VoiceControlIdle || state is VoiceControlError)) {
          add(StartWakeWordEvent());
        }
      });
    }
  }

  void _cancelRestartTimer() {
    _restartTimer?.cancel();
    _restartTimer = null;
  }

  @override
  Future<void> close() {
    _cancelRestartTimer();
    _audioPlayer.dispose();
    _ttsService.stop();
    return super.close();
  }
}
