import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> get isReady async {
    if (_isInitialized) return true;
    _isInitialized = await _speechToText.initialize(
      onError: (val) => print('STT Error: $val'),
      onStatus: (val) => print('STT Status: $val'),
    );
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
      print('STT Permission Denied');
      return;
    }

    if (await isReady) {
      print('STT Start Listening...');
      await _speechToText.listen(
        onResult: (result) {
          print(
            'STT Result: ${result.recognizedWords} (Final: ${result.finalResult})',
          );
          onResult(result.recognizedWords, result.finalResult);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: 'ru_RU',
        listenOptions: SpeechListenOptions(cancelOnError: true),
      );
    } else {
      print('STT is Not Ready');
    }
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
}
