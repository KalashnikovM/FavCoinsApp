// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class NotificationsService extends ChangeNotifier {
//
//   dfhbgfdhnb() async {
//   // You may set the permission requests to "provisional" which allows the user to choose what type
// // of notifications they would like to receive once the user receives a notification.
//   final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
//
// // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
//   final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//   if (apnsToken != null) {
//     debugPrint('apnsToken: $apnsToken');
//
//     // APNS token is available, make FCM plugin API requests...
//   }
// }
//
//
//
//   sdsdsdsd () async {
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('Got a message whilst in the foreground!');
//       debugPrint('Message data: ${message.data}');
//
//       if (message.notification != null) {
//         debugPrint('Message also contained a notification: ${message.notification}');
//       }
//     });
//
// }
//
//
//   @pragma('vm:entry-point')
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     // If you're going to use other Firebase services in the background, such as Firestore,
//     // make sure you call `initializeApp` before using other Firebase services.
//     await Firebase.initializeApp();
//
//     debugPrint("Handling a background message: ${message.messageId}");
//   }
//
//
//
//
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
  FlutterLocalNotificationsPlugin();
  String fcmToken = "";



  LocalNotification() {
    debugPrint('init LocalNotification');

    initialize();
  }

  Future<void> initialize() async {

   fcmToken = (await FirebaseMessaging.instance.getToken())!;
    debugPrint('fcmToken: $fcmToken');


    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload)
      async {   },
    );


    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    InitializationSettings initialSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,

    );
    _notificationPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('onDidReceiveNotificationResponse Function');
          debugPrint(details.payload);
          debugPrint((details.payload != null).toString());
        });


    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }


    FirebaseMessaging.onBackgroundMessage((message) async {

      showNotification(message);
    });

  }

  static void showNotification(RemoteMessage message) {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'com.example.push_notification',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
      ),

    );
    _notificationPlugin.show(
      DateTime.now().microsecond,
      message.notification!.title,
      message.notification!.body,
      details,
      payload: message.data.toString(),
    );
  }






}
