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
          primary:  Color(0xFFcecece),
          secondary: Color(0xFFcecece),
            onBackground: Color(0xFFcecece),
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


