import 'dart:developer' as developer;
import 'package:smart_chef_ai_assistant/src/core/services/classification_service_interface.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

/// Вспомогательный класс для шаблонов интентов
class _IntentTemplate {
  final VoiceAction action;
  final String phrase;
  final String parameter;

  const _IntentTemplate(this.action, this.phrase, this.parameter);
}

class OnDeviceClassificationService implements ClassificationServiceInterface {
  OnDeviceClassificationService();

  @override
  Future<VoiceCommand> classifyIntent(
    String transcription, {
    List<Recipe>? recipes,
    String? currentUrl,
  }) async {
    final normalizedTrans = transcription.toLowerCase().trim().replaceAll(
      'ё',
      'е',
    );
    if (normalizedTrans.isEmpty) {
      return VoiceCommand.unknown();
    }

    developer.log(
      'NLU Classifier: Обработка запроса: "$transcription"',
      name: 'AiService',
    );

    // 1. Попытка парсинга номера шага (цифры или числительные)
    String? extractedStepNum;
    final numberMatch = RegExp(r'\d+').firstMatch(normalizedTrans);
    if (numberMatch != null) {
      extractedStepNum = numberMatch.group(0);
    } else {
      final ordinals = {
        'первый': '1',
        'первого': '1',
        'первом': '1',
        'второй': '2',
        'второго': '2',
        'втором': '2',
        'третий': '3',
        'третьего': '3',
        'третьем': '3',
        'четвертый': '4',
        'четвертого': '4',
        'четвертом': '4',
        'пятый': '5',
        'пятого': '5',
        'пятом': '5',
        'шестой': '6',
        'седьмой': '7',
        'восьмой': '8',
        'девятый': '9',
        'десятый': '10',
      };
      for (final entry in ordinals.entries) {
        if (normalizedTrans.contains(entry.key)) {
          extractedStepNum = entry.value;
          break;
        }
      }
    }

    // 2. Создаем базу шаблонов интентов
    final templates = <_IntentTemplate>[];

    // --- ТЕМЫ ---
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'смени тему', 'toggle'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'поменяй тему', 'toggle'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'переключи тему', 'toggle'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'измени тему', 'toggle'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'включи темную тему', 'dark'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'включи светлую тему', 'light'),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.theme,
        'включи системную тему',
        'system',
      ),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'темная тема', 'dark'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'светлая тема', 'light'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.theme, 'системная тема', 'system'),
    );

    // --- НАВИГАЦИЯ ---
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'открой настройки',
        'settings',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'перейди в настройки',
        'settings',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'экран настроек',
        'settings',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'открой избранное',
        'favorites',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'перейди в избранное',
        'favorites',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'мои любимые рецепты',
        'favorites',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'открой список рецептов',
        'home',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.navigation,
        'перейди на главную',
        'home',
      ),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.navigation, 'главный экран', 'home'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.navigation, 'домой', 'home'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.navigation, 'все рецепты', 'home'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.navigation, 'список рецептов', 'home'),
    );

    // --- НАВИГАЦИЯ ПО ШАГАМ ---
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'следующий шаг', 'next'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'дальше', 'next'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'предыдущий шаг', 'prev'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'назад', 'prev'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'вернись назад', 'prev'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'открой шаг', 'step_num'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'покажи шаг', 'step_num'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.recipeStep, 'шаг', 'step_num'),
    );

    // --- ИЗБРАННОЕ ---
    templates.add(
      const _IntentTemplate(
        VoiceAction.favorite,
        'добавь в избранное',
        'current',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.favorite,
        'удали из избранного',
        'current',
      ),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.favorite, 'сохрани рецепт', 'current'),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.favorite,
        'убери из избранного',
        'current',
      ),
    );

    // --- ОЗВУЧКА ---
    templates.add(
      const _IntentTemplate(VoiceAction.readStep, 'озвучь шаг', 'current'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.readStep, 'прочитай шаг', 'current'),
    );
    templates.add(
      const _IntentTemplate(VoiceAction.readStep, 'повтори шаг', 'current'),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readStep,
        'озвучь следующий шаг',
        'next',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readStep,
        'прочитай следующий шаг',
        'next',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readStep,
        'озвучь предыдущий шаг',
        'prev',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readStep,
        'прочитай предыдущий шаг',
        'prev',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readStep,
        'расскажи следующий шаг',
        'next',
      ),
    );

    // --- ИНГРЕДИЕНТЫ ---
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'скажи ингредиенты',
        '',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'прочитай ингредиенты',
        '',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'что нужно для рецепта',
        '',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'список продуктов',
        '',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'список ингредиентов',
        '',
      ),
    );
    templates.add(
      const _IntentTemplate(
        VoiceAction.readIngredients,
        'какие ингредиенты',
        '',
      ),
    );

    // --- СПРАВКА ---
    templates.add(const _IntentTemplate(VoiceAction.help, 'помощь', ''));
    templates.add(const _IntentTemplate(VoiceAction.help, 'что ты умеешь', ''));
    templates.add(const _IntentTemplate(VoiceAction.help, 'список команд', ''));
    templates.add(const _IntentTemplate(VoiceAction.help, 'инструкция', ''));
    templates.add(const _IntentTemplate(VoiceAction.help, 'справка', ''));

    // --- ДИНАМИЧЕСКИЕ РЕЦЕПТЫ ИЗ БАЗЫ ДАННЫХ ---
    if (recipes != null) {
      for (final r in recipes) {
        final title = r.title.toLowerCase();
        templates.add(
          _IntentTemplate(VoiceAction.openRecipe, 'открой $title', r.id),
        );
        templates.add(
          _IntentTemplate(VoiceAction.openRecipe, 'покажи рецепт $title', r.id),
        );
        templates.add(
          _IntentTemplate(
            VoiceAction.openRecipe,
            'как приготовить $title',
            r.id,
          ),
        );
        templates.add(_IntentTemplate(VoiceAction.openRecipe, title, r.id));

        // Конкретные действия с избранным для этого рецепта
        templates.add(
          _IntentTemplate(
            VoiceAction.favorite,
            'добавь $title в избранное',
            r.id,
          ),
        );
        templates.add(
          _IntentTemplate(
            VoiceAction.favorite,
            'удали $title из избранного',
            r.id,
          ),
        );
      }
    }

    // 3. Вычисление наилучшего совпадения с использованием гибридного скоринга (N-граммы + покорневой охват слов)
    final userWords = _getCleanWords(normalizedTrans);

    _IntentTemplate? bestMatch;
    double maxScore = -1.0;

    for (final template in templates) {
      final templatePhraseNormalized = template.phrase.toLowerCase().replaceAll(
        'ё',
        'е',
      );
      // а) Коэффициент сходства Жаккара на уровне символьных N-грамм (для устойчивости к опечаткам)
      final charScore = _calculateSimilarity(
        normalizedTrans,
        templatePhraseNormalized,
      );

      // б) Покорневое совпадение слов (для исключения ложных совпадений коротких шаблонов типа "открой шаг")
      final templateWords = _getCleanWords(templatePhraseNormalized);
      int matchedUserWords = 0;
      for (final uWord in userWords) {
        bool isWordMatched = false;
        for (final tWord in templateWords) {
          if (_isRootMatch(uWord, tWord)) {
            isWordMatched = true;
            break;
          }
        }
        if (isWordMatched) {
          matchedUserWords++;
        }
      }
      final wordCoverage = userWords.isEmpty
          ? 0.0
          : matchedUserWords / userWords.length;

      // Гибридный скор: 30% символьное сходство + 70% точное покорневое совпадение слов
      final score = 0.3 * charScore + 0.7 * wordCoverage;

      if (score > maxScore) {
        maxScore = score;
        bestMatch = template;
      }
    }

    // Пороговое значение уверенности
    if (bestMatch == null || maxScore < 0.25) {
      developer.log(
        'NLU Classifier: Не удалось распознать команду. Макс. совпадение: $maxScore',
        name: 'AiService',
      );
      return VoiceCommand.unknown();
    }

    var parameter = bestMatch.parameter;
    if (parameter == 'step_num') {
      parameter = extractedStepNum ?? 'next';
    } else if (extractedStepNum != null &&
        (bestMatch.action == VoiceAction.recipeStep ||
            bestMatch.action == VoiceAction.readStep)) {
      // Если в запросе явно назван номер шага и распознано действие с шагами (переход или чтение),
      // используем именно этот номер в качестве параметра!
      parameter = extractedStepNum;
    }

    final result = VoiceCommand(
      action: bestMatch.action,
      parameters: parameter,
    );

    developer.log(
      'NLU Classifier: Успешно распознано за ${(1)}мс! Действие: ${result.action}, Параметры: ${result.parameters} (Совпадение: ${(maxScore * 100).toStringAsFixed(1)}%)',
      name: 'AiService',
    );

    return result;
  }

  /// Вычисление сходства Жаккара на базе символьных N-грамм и слов
  double _calculateSimilarity(String text1, String text2) {
    final nGrams1 = _getNGrams(text1);
    final nGrams2 = _getNGrams(text2);

    if (nGrams1.isEmpty || nGrams2.isEmpty) return 0.0;

    final intersection = nGrams1.intersection(nGrams2).length;
    final union = nGrams1.union(nGrams2).length;

    return intersection / union;
  }

  /// Получение набора N-грамм (слов, биграмм и триграмм)
  Set<String> _getNGrams(String text) {
    final cleanText = text.replaceAll(RegExp(r'[^\w\sа-яА-ЯёЁ]'), ' ');
    final nGrams = <String>{};

    final words = cleanText
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    for (final word in words) {
      nGrams.add(word); // Полное слово для точного совпадения

      // Символьные биграммы
      if (word.length >= 2) {
        for (var i = 0; i < word.length - 1; i++) {
          nGrams.add(word.substring(i, i + 2));
        }
      }

      // Символьные триграммы
      if (word.length >= 3) {
        for (var i = 0; i < word.length - 2; i++) {
          nGrams.add(word.substring(i, i + 3));
        }
      }
    }

    return nGrams;
  }

  /// Вспомогательный метод для получения чистых слов (длиной от 3 символов)
  List<String> _getCleanWords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\wа-яА-ЯёЁ\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && w.length >= 3)
        .toList();
  }

  /// Проверка совпадения корней слов
  bool _isRootMatch(String word1, String word2) {
    if (word1 == word2) return true;
    final minLength = word1.length < word2.length ? word1.length : word2.length;
    if (minLength < 3) return false;
    // Сравниваем первые 4 символа (или всю длину, если слово короче 4 символов)
    final matchLen = minLength > 4 ? 4 : minLength;
    return word1.substring(0, matchLen) == word2.substring(0, matchLen);
  }
}
