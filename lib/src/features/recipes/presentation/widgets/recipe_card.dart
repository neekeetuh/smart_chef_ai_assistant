// lib/features/1_recipe/presentation/widgets/recipe_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            SizedBox(
              height: 180,
              width: double.infinity,
              child: recipe.imageUrl.startsWith('http')
                  ? Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant_menu, color: Colors.grey),
                      ),
                    )
                  : (recipe.imageUrl.isNotEmpty
                      ? Image.file(
                          File(recipe.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.restaurant_menu, color: Colors.grey),
                        )),
            ),

            // Текст и кнопка
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: recipe.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
