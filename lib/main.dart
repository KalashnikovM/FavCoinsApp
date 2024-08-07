import 'dart:io';
import 'package:crypto_tracker/services/messaging_service.dart';
import 'package:crypto_tracker/ui/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'di/injections.dart';




void main() async {
  Platform.isIOS
      ? _iosStart()
      : _androidStart();
}


_iosStart() async {
  debugPrint('_iosStart()');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   LocalNotification().initialize();

  configureDependencies();
  runApp(const App());
}







_androidStart() async {
  debugPrint('_androidStart()');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint(fcmToken);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('User granted provisional permission');
  } else {
    debugPrint('User declined or has not accepted permission');
  }
  configureDependencies();

  runApp(const App());

}
