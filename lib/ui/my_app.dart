import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:watch_it/watch_it.dart';

import '../router/router.dart';



class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {

    return
      MaterialApp.router(
        theme: ThemeData.from(

          useMaterial3: true,
          colorScheme: const ColorScheme(
          primary:  Color(0xFF493367),
          secondary: Color(0xFFcecece),
            onBackground: Colors.green,
            background: Color(0xFF000000),
            onPrimary: Color(0xFF000000),
            brightness: Brightness.dark,
            onSecondary: Color(0xFF9b5bf3),
            error: Colors.red,
            onError: Colors.red,
            surface: Color(0xFF000000),
            onSurface: Color(0xFFcecece),

        ),),
        localizationsDelegates: const [
          // S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // locale: locale,
        supportedLocales: const [
          Locale('en'), // English
          Locale('vi'), // Vietnam
        ],
        routerConfig: di<AppRouter>().config(),
        // theme: lightTheme,
      );
  }
}









//https://pro.coinmarketcap.com/account
// // 0a6b4ad3-c373-4e67-8cae-2aaf4d951ce0
// 961fe869-42f5-4d39-8afe-9f0846b24fe6
// // startup_1st_month_free
// hobbyist_1st_month_free


// 65f7c7d944dc8aac6251 Project ID