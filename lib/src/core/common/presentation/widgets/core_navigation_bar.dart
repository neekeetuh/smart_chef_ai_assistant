import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_strings.dart';

class CoreNavigationBar extends StatelessWidget {
  const CoreNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
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
          icon: Icon(Icons.settings),
          label: AppStrings.settingsTitle,
        ),
      ],
    );
  }
}
