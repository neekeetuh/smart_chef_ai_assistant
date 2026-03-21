import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gigachat_dart/gigachat_dart.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class AiService {
  GigachatClient? _client;

  AiService();

  Future<void> _ensureInitialized() async {
    if (_client != null) return;

    final clientId = dotenv.env['GIGACHAT_CLIENT_ID'];
    final clientSecret = dotenv.env['GIGACHAT_CLIENT_SECRET'];

    if (clientId == null || clientSecret == null) {
      print(
        'ERROR: GIGACHAT_CLIENT_ID or GIGACHAT_CLIENT_SECRET is not defined in .env file',
      );
      return;
    }

    try {
      _client = GigachatClient(
        clientId: clientId,
        clientSecret: clientSecret,
        // В версии 0.1.2 scope передается как строка
        scope: 'GIGACHAT_API_PERS',
      );
    } catch (e) {
      print('GigaChat Initialization Error: $e');
    }
  }

  Future<VoiceCommand> classifyIntent(String transcription, {List<Recipe>? recipes}) async {
    await _ensureInitialized();
    if (_client == null) return VoiceCommand.unknown();

    String recipesContext = '';
    if (recipes != null && recipes.isNotEmpty) {
      recipesContext = '\nДоступные рецепты (ID и название):\n';
      for (var r in recipes) {
        recipesContext += '- ID: ${r.id}, название: ${r.title}\n';
      }
    }

    final systemPrompt = '''
Ты голосовой помощник для кулинарного приложения "Voice Chef". Твоя задача - классифицировать намерения пользователя по предоставленному тексту (транскрипции голоса).

Доступные действия:
1. "navigation" - переход на другие вкладки (настройки, избранное, главная страница).
   Параметры: settings, favorites, home.
2. "recipe_step" - управление шагами рецепта (следующий шаг, предыдущий шаг, шаг номер X).
   Параметры: next, prev, <номер шага>.
3. "theme" - смена темы приложения (светлая тема, темная тема, системная тема).
   Параметры: light, dark, system.
4. "open_recipe" - открытие конкретного рецепта по его названию.
   Параметры: ID рецепта (обязательно из предоставленного ниже списка).
$recipesContext
Верни ровно ОДИН валидный JSON-объект без разметки markdown. Пример правильного формата ответа:
{"action": "navigation", "parameters": "settings"}
{"action": "recipe_step", "parameters": "next"}
{"action": "theme", "parameters": "dark"}
{"action": "open_recipe", "parameters": "1"}
''';

    try {
      print('GigaChat: Отправка запроса для: "$transcription"');

      final response = await _client!.generateChatCompletion(
        request: Chat(
          model: 'GigaChat',
          messages: [
            Message(role: MessageRole.system, content: systemPrompt),
            Message(role: MessageRole.user, content: transcription),
          ],
          temperature: 0.1,
        ),
      );

      final choices = response.choices;
      if (choices == null || choices.isEmpty) {
        print('GigaChat Warning: Empty choices in response');
        return VoiceCommand.unknown();
      }

      final content = choices.first.message?.content;
      if (content == null) {
        print('GigaChat Warning: Empty content in first choice');
        return VoiceCommand.unknown();
      }

      print('GigaChat Content: $content');

      // Более надежное извлечение JSON: ищем первую '{' и последнюю '}'
      // Это поможет, если модель добавила лишний текст до или после JSON
      String jsonText = content.trim();
      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      // Очищаем от возможных markdown тегов, если они все еще внутри
      jsonText = jsonText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonText);
        return VoiceCommand.fromJson(jsonMap);
      } catch (e) {
        print('JSON Parsing Error in AiService: $e. Content was: $jsonText');
        return VoiceCommand.unknown();
      }
    } catch (e) {
      print('GigaChat Critical Error: $e');
    }

    return VoiceCommand.unknown();
  }
}
