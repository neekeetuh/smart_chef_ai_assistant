import 'dart:developer' as developer;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> init({
    required void Function(dynamic) onError,
    required void Function(String) onStatus,
  }) async {
    if (_isInitialized) return true;
    _isInitialized = await _speechToText.initialize(
      onError: (val) {
        developer.log(
          'STT Error Callback: $val',
          name: 'VoiceService',
          level: 1000,
        );
        onError(val);
      },
      onStatus: (val) {
        developer.log('STT Status Callback: $val', name: 'VoiceService');
        onStatus(val);
      },
    );
    return _isInitialized;
  }

  Future<bool> get isReady async {
    return _isInitialized;
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  Future<void> startListening({
    required Function(String, bool) onResult,
  }) async {
    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      developer.log('STT Permission Denied', name: 'VoiceService', level: 1000);
      return;
    }

    if (await isReady) {
      developer.log('STT Start Listening...', name: 'VoiceService');
      await _speechToText.listen(
        onResult: (result) {
          developer.log(
            'STT Result: ${result.recognizedWords} (Final: ${result.finalResult})',
            name: 'VoiceService',
          );
          onResult(result.recognizedWords, result.finalResult);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 10), // Увеличили таймаут тишины
        localeId: 'ru_RU',
        listenOptions: SpeechListenOptions(cancelOnError: true),
      );
    } else {
      developer.log('STT is Not Ready', name: 'VoiceService', level: 1000);
    }
  }

  Future<void> startWakeWordDetection({required Function() onDetected}) async {
    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) return;

    if (await isReady) {
      developer.log('STT Wake Word Detection Started...', name: 'VoiceService');
      await _speechToText.listen(
        onResult: (result) async {
          final text = result.recognizedWords.toLowerCase();
          if (text.contains('шеф') || text.contains('chef')) {
            developer.log('STT WAKE WORD DETECTED!', name: 'VoiceService');
            _speechToText.cancel(); // Немедленная остановка вместо ожидания
            onDetected();
          }
        },
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 30),
        localeId: 'ru_RU',
      );
    }
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
