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
    
    // Generate a unique notification ID using timestamp to avoid collisions
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
   
    if (notification != null && android != null) {
      showAndroidNotification(
        hashCode: notificationId,
        title: notification.title ?? '',
        body: notification.body ?? '',
        data: message.data,
      );
    } else if (notification != null) {
      _showIOSNotification(notification, message.data, notificationId);
    } else {
      debugPrint("🔴 [NOTIFICATION] No notification content found in message");
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
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            autoCancel: true,
            colorized: false,
            enableLights: true,
            // Use app icon as large icon for better visibility
            largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          ),
        ),
        payload: jsonEncode(data));
    
    debugPrint("🔔 [ANDROID NOTIFICATION] Notification show() called successfully");
  }

  void _showIOSNotification(RemoteNotification notification, Map<String, dynamic> data, int notificationId) {
    flutterLocalNotificationsPlugin.show(
        notificationId,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true, 
            presentBadge: true, 
            presentSound: true,
            badgeNumber: 1,
            threadIdentifier: 'ISEEY_notifications',
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
      debugPrint("🟢 [FCM] Message received: ${jsonEncode(message?.data)}");
      if (message != null) {
        debugPrint("🟢 [FCM] Notification title: ${message.notification?.title}");
        debugPrint("🟢 [FCM] Notification body: ${message.notification?.body}");
        
        var jsonData = message.data;
        var notificationType = jsonData['notification_type'] as String? ?? '';
        debugPrint("🟢 [FCM] Notification type: $notificationType");
        
        if (notificationType == 'chat_message') {
          var senderId = jsonData['sender_id'] as String? ?? '';
          debugPrint("🟢 [FCM] Chat message from sender: $senderId, current user: $globalChatUserId");
          if (senderId != globalChatUserId) {
            debugPrint("🟢 [FCM] Showing notification for chat message");
            showFlutterNotification(message);
          } else {
            debugPrint("🟡 [FCM] Skipping notification - message from current user");
          }
        } else {
          debugPrint("🟢 [FCM] Showing notification for type: $notificationType");
          showFlutterNotification(message);
        }
      } else {
        debugPrint("🔴 [FCM] Message is null");
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
