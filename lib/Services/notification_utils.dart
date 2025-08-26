import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iseey/AfterLoginFlow/Abc.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';

class NotificationUtils {
  // Future<void> initializeFirebaseApp() async {
  //   await Firebase.initializeApp();
  // }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  bool isFlutterLocalNotificationsInitialized = false;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    var notification = message.notification;
    var android = message.notification?.android;

    if (notification != null && android != null) {
      showAndroidNotification(
        hashCode: notification.hashCode,
        title: notification.title ?? '',
        body: notification.body ?? '',
        data: message.data,
      );
    } else if (notification != null) {
      _showIOSNotification(notification, message.data);
    }
  }

  void showAndroidNotification({
    required int hashCode,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    flutterLocalNotificationsPlugin.show(
        hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description!,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(data));
  }

  void _showIOSNotification(RemoteNotification notification, Map<String, dynamic> data) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true, 
            presentBadge: true, 
            presentSound: true
          ),
        ),
        payload: jsonEncode(data));
  }

  Future<void> initFirebaseActions(BuildContext context) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      
      // Disable foreground notifications
      defaultPresentAlert: true,
    );
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        openAppPageFromNotification(data: details.payload.toString(), fromInitialMessage: false, context: context);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        var jsonData = message.data;
        var notificationType = jsonData['notification_type'] as String? ?? '';
        if (notificationType == 'chat_message') {
          var senderId = jsonData['sender_id'] as String? ?? '';
          if (senderId != globalChatUserId) {
            showFlutterNotification(message);
          }
        } else {
          showFlutterNotification(message);
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        openAppPageFromNotification(data: jsonEncode(value.data), fromInitialMessage: true, context: context);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        openAppPageFromNotification(data: jsonEncode(message.data), fromInitialMessage: false, context: context);
      }
    });
    await getToken();
  }

  Future<void> getToken() async {
    var settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('FCM User granted provisional permission');
    } else {
      debugPrint('FCM User declined or has not accepted permission');
    }

    fcmRegistrationToken = await FirebaseMessaging.instance.getToken() ?? 'no token';
    // FirebaseMessaging.instance.subscribeToTopic(fcmRegistrationToken);
    debugPrint('FCM Registration Token: $fcmRegistrationToken');
    await setFCM(fcmRegistrationToken);
  }

  Future<void> openAppPageFromNotification({
    required String data,
    bool? fromInitialMessage,
    required BuildContext context,
  }) async {
    var message = jsonDecode(data) as Map<String, dynamic>;
    var notificationType = message['notification_type'] as String? ?? '';

    if (notificationType == 'chat_message' && !fromInitialMessage!) {
      customTabBarControllerKey.currentState?.openChat();
    } else {
      if (notificationType != "checkout") {
        return redirectToTest(context);
      }
    }
  }

  void redirectToTest(BuildContext? context) {
    globalNavigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Test()));
  }

  Future<void> clearAllNotifications() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
