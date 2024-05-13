import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/router.gr.dart';



@RoutePage(name: 'MainScreenRoute')
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Widget build MainScreen');


    return AutoTabsRouter(
      routes: const [
        HomePage(),
        PortfolioPage(),
        CoinListPage(),

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
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.circle, size: 28, color: Colors.purple,),
                icon: Icon(Icons.circle_outlined, size: 28, color: Colors.purple,),
                label: 'Top 100',),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.circle, size: 28, color: Colors.purple,),
                icon: Icon(Icons.circle_outlined, size: 28, color: Colors.purple,),
                label: 'Test',),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.circle, size: 28, color: Colors.purple,),
                icon: Icon(Icons.circle_outlined, size: 28, color: Colors.purple,),
                label: 'Test',),

            ],
          ),
        );
      },
    );
  }
}
