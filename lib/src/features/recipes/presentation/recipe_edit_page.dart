import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe_step.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class RecipeEditPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeEditPage({super.key, this.recipe});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  String? _imagePath;
  final List<TextEditingController> _ingredientControllers = [];
  final List<Map<String, TextEditingController>> _stepControllers = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe?.title ?? '');
    _imagePath = widget.recipe?.imageUrl;

    final ingredients = widget.recipe?.ingredients ?? [];
    for (var ing in ingredients) {
      _ingredientControllers.add(TextEditingController(text: ing));
    }

    final steps = widget.recipe?.steps ?? [];
    for (var step in steps) {
      _stepControllers.add({
        'title': TextEditingController(text: step.title),
        'desc': TextEditingController(text: step.description),
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var c in _ingredientControllers) {
      c.dispose();
    }
    for (var map in _stepControllers) {
      map['title']?.dispose();
      map['desc']?.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final id = widget.recipe?.id ?? const Uuid().v4();
      final recipe = Recipe(
        id: id,
        title: _titleController.text,
        imageUrl: _imagePath ?? '',
        ingredients: _ingredientControllers
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
        steps: _stepControllers
            .map(
              (map) => RecipeStep(
                title: map['title']!.text.trim(),
                description: map['desc']!.text.trim(),
              ),
            )
            .where((s) => s.title.isNotEmpty || s.description.isNotEmpty)
            .toList(),
        isFavorite: widget.recipe?.isFavorite ?? false,
        updatedAt: DateTime.now(),
      );

      context.read<RecipeBloc>().add(SaveRecipeEvent(recipe));
      context.router.pop(recipe);
    }
  }

  Widget _buildImagePreview() {
    if (_imagePath == null || _imagePath!.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(child: Text('Нет фото. Нажмите чтобы добавить.')),
      );
    }

    if (_imagePath!.startsWith('http')) {
      return Image.network(
        _imagePath!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(_imagePath!),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe == null ? 'Новый рецепт' : 'Редактировать рецепт',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveRecipe),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImagePreview(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название рецепта',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Введите название' : null,
            ),
            const SizedBox(height: 24),
            Text('Ингредиенты', style: Theme.of(context).textTheme.titleLarge),
            ..._ingredientControllers.asMap().entries.map((entry) {
              int idx = entry.key;
              final controller = entry.value;
              return Row(
                key: ObjectKey(controller),
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Ингредиент'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        final c = _ingredientControllers.removeAt(idx);
                        c.dispose();
                      });
                    },
                  ),
                ],
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(
                  () => _ingredientControllers.add(TextEditingController()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить ингредиент'),
            ),
            const SizedBox(height: 24),
            Text('Шаги', style: Theme.of(context).textTheme.titleLarge),
            ..._stepControllers.asMap().entries.map((entry) {
              int idx = entry.key;
              final map = entry.value;
              return Card(
                key: ObjectKey(map),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Шаг ${idx + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                final removed = _stepControllers.removeAt(idx);
                                removed['title']?.dispose();
                                removed['desc']?.dispose();
                              });
                            },
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: map['title'],
                        decoration: const InputDecoration(
                          labelText: 'Заголовок шага',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: map['desc'],
                        decoration: const InputDecoration(
                          labelText: 'Описание шага',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(
                  () => _stepControllers.add({
                    'title': TextEditingController(),
                    'desc': TextEditingController(),
                  }),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить шаг'),
            ),
          ],
        ),
      ),
    );
  }
}
