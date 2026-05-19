import 'package:equatable/equatable.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe_step.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<RecipeStep> steps;
  final bool isFavorite;
  final DateTime? updatedAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    this.isFavorite = false,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    imageUrl,
    ingredients,
    steps,
    isFavorite,
    updatedAt,
  ];

  Recipe copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<String>? ingredients,
    List<RecipeStep>? steps,
    bool? isFavorite,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'steps': steps.map((s) => s.toJson()).toList(),
    'isFavorite': isFavorite,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    title: json['title'],
    imageUrl: json['imageUrl'],
    ingredients: List<String>.from(json['ingredients']),
    steps: (json['steps'] as List).map((s) => RecipeStep.fromJson(s)).toList(),
    isFavorite: json['isFavorite'] ?? false,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  );
}
