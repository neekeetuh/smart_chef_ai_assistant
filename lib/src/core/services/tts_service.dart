import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _init();
  }

  Future<void> _init() async {
    await _flutterTts.setLanguage('ru-RU');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(0.9);

    try {
      final dynamic engines = await _flutterTts.getEngines;
      print('TTS: Available engines: $engines');

      final dynamic voices = await _flutterTts.getVoices;
      if (voices is List) {
        final ruVoices = voices.where((v) {
          final loc = (v['locale']?.toString() ?? '').toLowerCase();
          return loc.startsWith('ru');
        }).toList();

        print('TTS: Found ${ruVoices.length} RU-compatible voices.');

        // Список подстрок, которые обычно указывают на мужской голос в разных системах
        const malePatterns = [
          'rud',
          'dfc',
          'male',
          'yuri',
          'maxim',
          'pavel',
          'arthur',
          'ruo',
          'rua',
        ];

        bool maleFound = false;
        // Мы НЕ выбираем рандомный голос. Мы идем по списку системных голосов
        // и берем ПЕРВЫЙ, который содержит один из мужских паттернов.
        for (final voice in ruVoices) {
          final name = voice['name']?.toString().toLowerCase() ?? '';

          if (malePatterns.any((pattern) => name.contains(pattern))) {
            await _flutterTts.setVoice({
              "name": voice['name'],
              "locale": voice['locale'],
            });
            await _flutterTts.setPitch(0.85);
            print('TTS: Selected male voice: $name');
            maleFound = true;
            break;
          }
        }

        if (!maleFound) {
          print(
            'TTS: No male patterns found. Using default voice with low pitch.',
          );
          await _flutterTts.setPitch(0.7);
        }
      }
    } catch (e) {
      print('TTS: Critical init error: $e');
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
