import 'package:equatable/equatable.dart';

class RecipeStep extends Equatable {
  final String title;
  final String description;

  const RecipeStep({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];

  Map<String, dynamic> toJson() => {'title': title, 'description': description};

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      RecipeStep(title: json['title'], description: json['description']);
}
