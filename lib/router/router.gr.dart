// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:crypto_tracker/models/main_coin_model.dart' as _i9;
import 'package:crypto_tracker/ui/coin_page/coin_page.dart' as _i1;
import 'package:crypto_tracker/ui/favorites_page/favorites_page.dart' as _i2;
import 'package:crypto_tracker/ui/global_list_page/global_list_page.dart'
    as _i3;
import 'package:crypto_tracker/ui/main_screen/main_screen.dart' as _i4;
import 'package:crypto_tracker/ui/splash_screen/splash_screen.dart' as _i5;
import 'package:crypto_tracker/ui/top_list_page/top_list_page.dart' as _i6;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    CoinPage.name: (routeData) {
      final args = routeData.argsAs<CoinPageArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CoinPage(
          key: args.key,
          model: args.model,
        ),
      );
    },
    FavoritesPage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.FavoritesPage(),
      );
    },
    GlobalListPage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.GlobalListPage(),
      );
    },
    MainScreenRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MainScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SplashScreen(),
      );
    },
    Top100ListPage.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.Top100ListPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.CoinPage]
class CoinPage extends _i7.PageRouteInfo<CoinPageArgs> {
  CoinPage({
    _i8.Key? key,
    required _i9.MainCoinModel model,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          CoinPage.name,
          args: CoinPageArgs(
            key: key,
            model: model,
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
  });

  final _i8.Key? key;

  final _i9.MainCoinModel model;

  @override
  String toString() {
    return 'CoinPageArgs{key: $key, model: $model}';
  }
}

/// generated route for
/// [_i2.FavoritesPage]
class FavoritesPage extends _i7.PageRouteInfo<void> {
  const FavoritesPage({List<_i7.PageRouteInfo>? children})
      : super(
          FavoritesPage.name,
          initialChildren: children,
        );

  static const String name = 'FavoritesPage';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.GlobalListPage]
class GlobalListPage extends _i7.PageRouteInfo<void> {
  const GlobalListPage({List<_i7.PageRouteInfo>? children})
      : super(
          GlobalListPage.name,
          initialChildren: children,
        );

  static const String name = 'GlobalListPage';

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
/// [_i5.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.Top100ListPage]
class Top100ListPage extends _i7.PageRouteInfo<void> {
  const Top100ListPage({List<_i7.PageRouteInfo>? children})
      : super(
          Top100ListPage.name,
          initialChildren: children,
        );

  static const String name = 'Top100ListPage';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
