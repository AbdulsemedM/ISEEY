import 'dart:io';

import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/Services/notification_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NavigationRouteScreen.dart';
import 'Services/StateManagement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationUtils().initializeFirebaseApp();
  FirebaseMessaging.onBackgroundMessage(
    (message) async {
      await _firebaseMessagingBackgroundHandler(message);
    },
  );

  await NotificationUtils().setupFlutterNotifications();

  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => StateManagement(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: globalNavigatorKey,
        home: NavigationRouteScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationUtils().initializeFirebaseApp();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
