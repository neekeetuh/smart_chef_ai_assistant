import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_chef_ai_assistant/src/core/navigation/app_router.dart';
import 'package:smart_chef_ai_assistant/src/features/recipe_generator/data/services/ai_recipe_generator_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

@RoutePage()
class RecipeGeneratorPage extends StatefulWidget {
  const RecipeGeneratorPage({super.key});

  @override
  State<RecipeGeneratorPage> createState() => _RecipeGeneratorPageState();
}

class _RecipeGeneratorPageState extends State<RecipeGeneratorPage> {
  final TextEditingController _promptController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (val) => setState(() {
            _promptController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  Future<void> _generateRecipe() async {
    if (_promptController.text.trim().isEmpty) return;

    if (_isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    }
    
    setState(() => _isLoading = true);
    
    try {
      final generator = context.read<AiRecipeGeneratorService>();
      final generatedRecipe = await generator.generateRecipe(_promptController.text.trim());
      
      setState(() => _isLoading = false);
      
      if (generatedRecipe != null && mounted) {
        context.router.push(GeneratedRecipePreviewRoute(
          recipe: generatedRecipe,
          prompt: _promptController.text.trim(),
        ));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ошибка генерации'),
            content: const Text('Эта функция требует стабильного подключения к интернету. Проверьте соединение и попробуйте снова.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ОК'),
              )
            ],
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ИИ Генератор Рецептов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Опишите, какое блюдо вы хотите приготовить, или перечислите имеющиеся ингредиенты:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: _promptController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Например: "У меня есть курица, картошка и сливки. Что можно приготовить?"',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                        bottom: 48,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : null,
                      ),
                      onPressed: _listen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateRecipe,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Сгенерировать рецепт', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
