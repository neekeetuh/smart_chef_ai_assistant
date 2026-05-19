import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_chef_ai_assistant/src/core/services/smart_classification_service.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/handlers/voice_command_handler.dart';
import 'package:smart_chef_ai_assistant/src/features/voice_control/domain/models/voice_command.dart';

class UnsupportedCommandHandler implements VoiceCommandHandler {
  @override
  bool canHandle(VoiceCommand command) => command.action == VoiceAction.unsupported;

  @override
  void handle(BuildContext context, VoiceCommand command) {
    if (command.unsupportedReason == UnsupportedReason.generateRecipe) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.cloud_off, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text('Режим классификации'),
              ),
            ],
          ),
          content: const Text(
            'Генерация рецептов с помощью ИИ поддерживается только в облачном (LLM) режиме классификации команд. '
            'Хотите включить облачный режим классификации прямо сейчас?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                // Включаем облачный режим классификации
                context.read<SmartClassificationService>().setClassificationMode(ClassificationMode.llm);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Облачный (LLM) режим классификации успешно включен! Попробуйте сгенерировать рецепт еще раз.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Включить'),
            ),
          ],
        ),
      );
    }
  }
}
