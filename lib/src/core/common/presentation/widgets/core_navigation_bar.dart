import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';

class CoreNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CoreNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: 0, // Убираем тень, т.к. она на BottomAppBar
        type: BottomNavigationBarType.fixed, // Чтобы элементы не смещались
        backgroundColor:
            Colors.transparent, // Фон прозрачный, чтобы BottomAppBar его задал
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.homeTitle,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: AppStrings.favoritesTitle,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'ИИ Шеф',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settingsTitle,
          ),
        ],
      ),
    );
  }
}
