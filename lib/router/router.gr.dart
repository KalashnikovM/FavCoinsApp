// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:crypto_tracker/models/main_coin_model.dart' as _i9;
import 'package:crypto_tracker/ui/coin_list_page/coin_list_page.dart' as _i1;
import 'package:crypto_tracker/ui/coin_page/coin_page.dart' as _i2;
import 'package:crypto_tracker/ui/home_page/home_page.dart' as _i3;
import 'package:crypto_tracker/ui/main_screen/main_screen.dart' as _i4;
import 'package:crypto_tracker/ui/portfolio_page/portfolio_page.dart' as _i5;
import 'package:crypto_tracker/ui/splash_screen/splash_screen.dart' as _i6;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    CoinListPage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CoinListPage(),
      );
    },
    CoinPage.name: (routeData) {
      final args = routeData.argsAs<CoinPageArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.CoinPage(
          key: args.key,
          model: args.model,
          image: args.image,
        ),
      );
    },
    HomePage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
      );
    },
    MainScreenRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MainScreen(),
      );
    },
    PortfolioPage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.PortfolioPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.CoinListPage]
class CoinListPage extends _i7.PageRouteInfo<void> {
  const CoinListPage({List<_i7.PageRouteInfo>? children})
      : super(
          CoinListPage.name,
          initialChildren: children,
        );

  static const String name = 'CoinListPage';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.CoinPage]
class CoinPage extends _i7.PageRouteInfo<CoinPageArgs> {
  CoinPage({
    _i8.Key? key,
    required _i9.MainCoinModel model,
    required _i8.Image image,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          CoinPage.name,
          args: CoinPageArgs(
            key: key,
            model: model,
            image: image,
          ),
          initialChildren: children,
        );

  static const String name = 'CoinPage';

  static const _i7.PageInfo<CoinPageArgs> page =
      _i7.PageInfo<CoinPageArgs>(name);
}

class CoinPageArgs {
  const CoinPageArgs({
    this.key,
    required this.model,
    required this.image,
  });

  final _i8.Key? key;

  final _i9.MainCoinModel model;

  final _i8.Image image;

  @override
  String toString() {
    return 'CoinPageArgs{key: $key, model: $model, image: $image}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomePage extends _i7.PageRouteInfo<void> {
  const HomePage({List<_i7.PageRouteInfo>? children})
      : super(
          HomePage.name,
          initialChildren: children,
        );

  static const String name = 'HomePage';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MainScreen]
class MainScreenRoute extends _i7.PageRouteInfo<void> {
  const MainScreenRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MainScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainScreenRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.PortfolioPage]
class PortfolioPage extends _i7.PageRouteInfo<void> {
  const PortfolioPage({List<_i7.PageRouteInfo>? children})
      : super(
          PortfolioPage.name,
          initialChildren: children,
        );

  static const String name = 'PortfolioPage';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
