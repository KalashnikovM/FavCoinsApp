import 'package:auto_route/auto_route.dart';
import 'package:crypto_tracker/router/router.gr.dart';




@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: SplashRoute.page, initial: true),
    // AutoRoute(path: '/HomePage', page: HomePage.page),
    // AutoRoute(path: '/PortfolioPage', page: PortfolioPage.page),
    // AutoRoute(path: '/CoinListPage', page: CoinListPage.page),

    AutoRoute(path: '/MainScreenRoute', page: MainScreenRoute.page,
      children: [
        AutoRoute(path: 'HomePage', page: HomePage.page),
        AutoRoute(path: 'PortfolioPage', page: PortfolioPage.page),
        AutoRoute(path: 'CoinListPage', page: CoinListPage.page),
      ],
    ),
    AutoRoute(path: '/CoinPage', page: CoinPage.page),

  ];




}

// class AuthGuard extends AutoRouteGuard {
//
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     di<AuthStatus>().isLoggedIn
//         ? resolver.redirect(const MainScreenRoute())
//         : resolver.redirect(const SplashRoute());
//   }
// }
