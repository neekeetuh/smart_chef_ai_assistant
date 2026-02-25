enum VoiceAction {
  navigation,
  recipeStep,
  theme,
  unknown;

  static VoiceAction fromString(String action) {
    switch (action.toLowerCase()) {
      case 'navigation':
        return VoiceAction.navigation;
      case 'recipe_step':
      case 'recipeStep':
        return VoiceAction.recipeStep;
      case 'theme':
        return VoiceAction.theme;
      default:
        return VoiceAction.unknown;
    }
  }
}

class VoiceCommand {
  final VoiceAction action;
  final String parameters;

  VoiceCommand({required this.action, required this.parameters});

  factory VoiceCommand.fromJson(Map<String, dynamic> json) {
    return VoiceCommand(
      action: VoiceAction.fromString(json['action'] ?? ''),
      parameters: json['parameters']?.toString() ?? '',
    );
  }

  factory VoiceCommand.unknown() {
    return VoiceCommand(action: VoiceAction.unknown, parameters: '');
  }
}
