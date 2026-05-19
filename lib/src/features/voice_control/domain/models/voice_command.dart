enum VoiceAction {
  navigation,
  recipeStep,
  theme,
  openRecipe,
  favorite,
  readStep,
  readIngredients,
  help,
  generateRecipe,
  unsupported,
  unknown;

  static VoiceAction fromString(String action) {
    switch (action.toLowerCase()) {
      case 'navigation':
        return VoiceAction.navigation;
      case 'recipe_step':
      case 'recipeStep':
        return VoiceAction.recipeStep;
      case 'read_step':
      case 'readStep':
        return VoiceAction.readStep;
      case 'read_ingredients':
      case 'readIngredients':
      case 'ингредиенты':
      case 'ingredients':
        return VoiceAction.readIngredients;
      case 'theme':
        return VoiceAction.theme;
      case 'open_recipe':
      case 'openrecipe':
        return VoiceAction.openRecipe;
      case 'favorite':
      case 'toggle_favorite':
        return VoiceAction.favorite;
      case 'help':
      case 'show_help':
      case 'помощь':
      case 'инструкция':
        return VoiceAction.help;
      case 'generate_recipe':
      case 'generaterecipe':
        return VoiceAction.generateRecipe;
      case 'unsupported':
        return VoiceAction.unsupported;
      default:
        return VoiceAction.unknown;
    }
  }
}

enum UnsupportedReason {
  /// Генерация рецепта с помощью ИИ (требует облачный режим классификации)
  generateRecipe,
  /// Команда поддерживается в текущем режиме
  none,
}

class VoiceCommand {
  final VoiceAction action;
  final String parameters;
  final UnsupportedReason unsupportedReason;

  VoiceCommand({
    required this.action,
    required this.parameters,
    this.unsupportedReason = UnsupportedReason.none,
  });

  factory VoiceCommand.fromJson(Map<String, dynamic> json) {
    return VoiceCommand(
      action: VoiceAction.fromString(json['action'] ?? ''),
      parameters: json['parameters']?.toString() ?? '',
      unsupportedReason: UnsupportedReason.none,
    );
  }

  factory VoiceCommand.unknown() {
    return VoiceCommand(
      action: VoiceAction.unknown,
      parameters: '',
      unsupportedReason: UnsupportedReason.none,
    );
  }

  factory VoiceCommand.unsupported({required UnsupportedReason reason}) {
    return VoiceCommand(
      action: VoiceAction.unsupported,
      parameters: '',
      unsupportedReason: reason,
    );
  }

  VoiceCommand copyWith({
    VoiceAction? action,
    String? parameters,
    UnsupportedReason? unsupportedReason,
  }) {
    return VoiceCommand(
      action: action ?? this.action,
      parameters: parameters ?? this.parameters,
      unsupportedReason: unsupportedReason ?? this.unsupportedReason,
    );
  }
}
