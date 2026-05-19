import 'package:flutter/material.dart';

class VoiceHelpBottomSheet extends StatelessWidget {
  const VoiceHelpBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceHelpBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Доступные команды',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CommandItem(
            icon: Icons.navigation,
            title: 'Навигация',
            subtitle: 'На главную, в избранное, в настройки',
            examples: const ['"перейди в настройки"', '"открой избранное"'],
          ),
          _CommandItem(
            icon: Icons.restaurant_menu,
            title: 'Рецепты',
            subtitle: 'Открытие страницы рецепта',
            examples: const ['"открой рецепт борща"', '"покажи салат цезарь"'],
          ),
          _CommandItem(
            icon: Icons.psychology,
            title: 'ИИ Генерация (нужен интернет)',
            subtitle: 'Генерация новых рецептов по вашим пожеланиям',
            examples: const ['"сгенерируй рецепт мясного блюда с гарниром"', '"создай рецепт веганского пирога"'],
          ),
          _CommandItem(
            icon: Icons.palette,
            title: 'Интерфейс',
            subtitle: 'Смена темы оформления',
            examples: const ['"включи темную тему"', '"смени тему"'],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Попробуйте еще раз с этими фразами',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: kToolbarHeight),
        ],
      ),
    );
  }
}

class _CommandItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> examples;

  const _CommandItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.examples,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 4),
                ...examples.map(
                  (e) => Text(
                    e,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
