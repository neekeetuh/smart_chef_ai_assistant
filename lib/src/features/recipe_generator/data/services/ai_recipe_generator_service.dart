import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gigachat_dart/gigachat_dart.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe_step.dart';
import 'package:uuid/uuid.dart';

class AiRecipeGeneratorService {
  GigachatClient? _client;

  AiRecipeGeneratorService();

  Future<void> _ensureInitialized() async {
    if (_client != null) return;

    final clientId = dotenv.env['GIGACHAT_CLIENT_ID'];
    final clientSecret = dotenv.env['GIGACHAT_CLIENT_SECRET'];

    if (clientId == null || clientSecret == null) {
      developer.log(
        'GIGACHAT_CLIENT_ID or GIGACHAT_CLIENT_SECRET is not defined in .env file',
        name: 'AiGeneratorService',
      );
      return;
    }

    try {
      _client = GigachatClient(
        clientId: clientId,
        clientSecret: clientSecret,
        scope: 'GIGACHAT_API_PERS',
      );
    } catch (e) {
      developer.log('GigaChat Initialization Error: $e', name: 'AiGeneratorService');
    }
  }

  Future<Recipe?> generateRecipe(String prompt) async {
    await _ensureInitialized();
    if (_client == null) throw Exception("GigaChat client not initialized");

    final systemPrompt = '''
Ты профессиональный шеф-повар. Пользователь описывает рецепт, ингредиенты или пожелания. Твоя задача сгенерировать подробный рецепт.
Верни ТОЛЬКО валидный JSON-объект в формате:
{
  "title": "Название блюда",
  "ingredients": ["Ингредиент 1", "Ингредиент 2"],
  "steps": [
    {"title": "Шаг 1", "description": "Описание шага 1"},
    {"title": "Шаг 2", "description": "Описание шага 2"}
  ]
}
Не добавляй никакого текста кроме этого JSON!
''';

    try {
      final response = await _client!.generateChatCompletion(
        request: Chat(
          model: 'GigaChat',
          messages: [
            Message(role: MessageRole.system, content: systemPrompt),
            Message(role: MessageRole.user, content: prompt),
          ],
          temperature: 0.7,
        ),
      );

      final content = response.choices?.first.message?.content;
      if (content == null) throw Exception("Empty response from LLM");

      String jsonText = content.trim();
      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      jsonText = jsonText.replaceAll('```json', '').replaceAll('```', '').trim();

      final Map<String, dynamic> jsonMap = jsonDecode(jsonText);

      return Recipe(
        id: const Uuid().v4(),
        title: jsonMap['title'] ?? 'Сгенерированный рецепт',
        imageUrl: '', // Изображения генерировать не умеет, будет плейсхолдер
        ingredients: List<String>.from(jsonMap['ingredients'] ?? []),
        steps: (jsonMap['steps'] as List?)
                ?.map((s) => RecipeStep(title: s['title'] ?? '', description: s['description'] ?? ''))
                .toList() ??
            [],
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      developer.log('Generation error: $e', name: 'AiGeneratorService');
      throw Exception("Network or Generation Error: $e");
    }
  }
}
