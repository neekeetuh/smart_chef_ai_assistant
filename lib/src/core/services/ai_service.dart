import 'dart:convert';
import 'dart:developer' as developer;
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
      developer.log(
        'GIGACHAT_CLIENT_ID or GIGACHAT_CLIENT_SECRET is not defined in .env file',
        name: 'AiService',
        level: 1000,
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
      developer.log('GigaChat Initialization Error: $e', name: 'AiService', error: e);
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
   - Используй "home" для команд: "открой все рецепты", "список рецептов", "главный экран", "домой".
   - Используй "favorites" для команд: "открой избранное", "покажи мои рецепты", "список избранных".
2. "recipe_step" - навигация (ПЕРЕЛИСТЫВАНИЕ) по шагам рецепта БЕЗ автоматической озвучки.
   - Используй для команд: "следующий шаг", "предыдущий", "назад", "открой шаг номер 5", "покажи 2 шаг".
   Параметры: next, prev, <номер шага>.
3. "theme" - смена темы приложения (светлая/темная/системная).
   - Если пользователь просит КОНКРЕТНУЮ тему (например "включи темную"), используй параметры: light, dark, system.
   - Если пользователь просит СМЕНИТЬ или ПОМЕНЯТЬ тему без уточнения (например "смени тему", "переключи тему"), используй параметр: toggle.
4. "open_recipe" - открытие КОНКРЕТНОГО рецепта из списка ниже.
   Параметры: ID рецепта (обязательно из предоставленного ниже списка).
   - ВНИМАНИЕ: НЕ используй это действие для команд "открой все рецепты", "список рецептов" или "все блюда". Для таких команд ВСЕГДА используй "navigation" с параметром "home".
   - Если пользователь просит "любой", "рандомный" или "какой-нибудь" рецепт, выбери ЛЮБОЙ ID из списка ниже.
5. "favorite" - действие ДОБАВЛЕНИЯ или УДАЛЕНИЯ конкретного рецепта из списка избранного.
   - Если пользователь говорит "добавь в избранное", "удали из избранного" (находясь на странице рецепта), используй параметр: current.
   - ВНИМАНИЕ: Если пользователь просит ОТКРЫТЬ или ПОКАЗАТЬ список избранного, используй "navigation" с параметром "favorites".
   - Если пользователь говорит о конкретном рецепте по имени (находясь на любом экране), выбери соответствующий ID из списка ниже.
6. "read_step" - ОЗВУЧИВАНИЕ (чтение вслух) текста шага.
   - Используй для команд: "озвучь", "прочитай", "воспроизведи", "повтори", "расскажи следующий шаг".
   Параметры: next, prev, <номер шага>, current (если нужно прочитать текущий открытый шаг еще раз).
7. "help" - запрос списка команд (что ты умеешь?, список действий, помощь, инструкция).
   Параметры: не требуются.
$recipesContext
Верни ровно ОДИН валидный JSON-объект без разметки markdown. Пример правильного формата ответа:
{"action": "navigation", "parameters": "settings"}
{"action": "recipe_step", "parameters": "next"}
{"action": "theme", "parameters": "dark"}
{"action": "theme", "parameters": "toggle"}
{"action": "open_recipe", "parameters": "1"}
{"action": "help", "parameters": ""}
''';

    try {
      developer.log('GigaChat: Отправка запроса для: "$transcription"', name: 'AiService');

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
        developer.log('GigaChat Warning: Empty choices in response', name: 'AiService');
        return VoiceCommand.unknown();
      }

      final content = choices.first.message?.content;
      if (content == null) {
        developer.log('GigaChat Warning: Empty content in first choice', name: 'AiService');
        return VoiceCommand.unknown();
      }

      developer.log('GigaChat Content: $content', name: 'AiService');

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
        developer.log('JSON Parsing Error in AiService: $e. Content was: $jsonText', name: 'AiService', error: e);
        return VoiceCommand.unknown();
      }
    } catch (e) {
      developer.log('GigaChat Critical Error: $e', name: 'AiService', error: e);
    }

    return VoiceCommand.unknown();
  }
}
