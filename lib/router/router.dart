import 'package:auto_route/auto_route.dart';
import 'package:crypto_tracker/router/router.gr.dart';




@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: SplashRoute.page, initial: true),
    AutoRoute(path: '/MainScreenRoute', page: MainScreenRoute.page,
      children: [
        AutoRoute(path: 'Top100ListPage', page: Top100ListPage.page),
        AutoRoute(path: 'GlobalListPage', page: GlobalListPage.page),
        AutoRoute(path: 'FavoritesPage', page: FavoritesPage.page),
      ],
    ),
    AutoRoute(path: '/CoinPage', page: CoinPage.page),

  ];


}
