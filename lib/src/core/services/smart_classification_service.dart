import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef_ai_assistant/src/core/services/ai_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/core/services/classification_service_interface.dart';
import 'package:smart_chef_ai_assistant/src/core/services/on_device_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

enum ClassificationMode { llm, onDevice }

class SmartClassificationService extends ChangeNotifier
    implements ClassificationServiceInterface {
  final AiClassificationService _llmService;
  final OnDeviceClassificationService _onDeviceService;

  ClassificationMode _currentMode = ClassificationMode.onDevice;
  static const String _prefKey = 'classification_mode';

  SmartClassificationService({
    required AiClassificationService llmService,
    required OnDeviceClassificationService onDeviceService,
  }) : _llmService = llmService,
       _onDeviceService = onDeviceService {
    _loadPersistedMode();
  }

  ClassificationMode get currentMode => _currentMode;

  Future<void> _loadPersistedMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_prefKey);
      if (savedMode != null) {
        if (savedMode == 'llm') {
          _currentMode = ClassificationMode.llm;
        } else {
          _currentMode = ClassificationMode.onDevice;
        }
        notifyListeners();
      }
    } catch (_) {
      // Игнорируем ошибки при инициализации, используем режим по умолчанию
    }
  }

  Future<void> setClassificationMode(ClassificationMode mode) async {
    if (_currentMode == mode) return;
    _currentMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefKey,
        mode == ClassificationMode.llm ? 'llm' : 'onDevice',
      );
    } catch (_) {
      // Игнорируем ошибки сохранения
    }
  }

  @override
  Future<VoiceCommand> classifyIntent(
    String transcription, {
    List<Recipe>? recipes,
    String? currentUrl,
  }) async {
    if (_currentMode == ClassificationMode.llm) {
      return _llmService.classifyIntent(
        transcription,
        recipes: recipes,
        currentUrl: currentUrl,
      );
    } else {
      return _onDeviceService.classifyIntent(
        transcription,
        recipes: recipes,
        currentUrl: currentUrl,
      );
    }
  }
}
