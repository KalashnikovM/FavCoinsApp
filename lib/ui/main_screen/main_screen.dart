import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../router/router.gr.dart';



@RoutePage(name: 'MainScreenRoute')
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Widget build MainScreen');
    Icon activeIcon = const Icon(
      Icons.circle,
      size: 28,
      color: AppColors.mainGreen,
    );
        Icon inActiveIcon = const Icon(
          Icons.circle_outlined,
          size: 28,
          color: AppColors.mainRed,

        );

    return AutoTabsRouter(
      routes: const [
        Top100ListPage(),
        GlobalListPage(),
        FavoritesPage(),
      ],
      transitionBuilder: (context,child,animation)=> FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final itemsRouter =  AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar (
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: const IconThemeData(
                size: 23,
                // color: AppColor.kAccessibleSystemBlueLight
            ),
            unselectedIconTheme: const IconThemeData(
                size: 23,
                // color: AppColor.kDefaultSystemGraySecondaryLight
            ),
            currentIndex: itemsRouter.activeIndex,
            onTap: (value) {
              itemsRouter.setActiveIndex(value);
            } ,
            items: [
              BottomNavigationBarItem(
                activeIcon: activeIcon,
                icon: inActiveIcon,
                label: 'Top 100',),
              BottomNavigationBarItem(
                activeIcon: activeIcon,
                icon: inActiveIcon,
                label: 'Global list',),
              BottomNavigationBarItem(
                activeIcon: activeIcon,
                icon: inActiveIcon,
                label: 'Favorites',),

            ],
          ),
        );
      },
    );
  }
}
