import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/controller/restaurant_list_controller.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/domain/restaurant_list_repository.dart';
import 'package:iseey/AfterLoginFlow/chat/controller/chat_controller.dart';
import 'package:iseey/AuthFlow/domain/auth_repository.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/domain/Edit_profile_repository.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/Services/notification_utils.dart';
import 'package:iseey/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:iseey/Services/ApiService.dart';
import 'NavigationRouteScreen.dart';
import 'Services/StateManagement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  } catch (e) {
    // Hot restart: native Firebase already has [DEFAULT], Dart VM was restarted
    if (e.toString().contains('duplicate-app') == false) rethrow;
  }

  // Configure Firebase to show notifications when app is in foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await NotificationUtils().setupFlutterNotifications();
  HttpOverrides.global = MyHttpOverrides();

  final apiService = HttpService();
  final authRepository = AuthRepository(apiService);
  final profileRepository = EditProfileRepository(apiService);

  final stateManagement = StateManagement();
  await stateManagement.loadCurrentUserId();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StateManagement>(
          create: (BuildContext context) => stateManagement,
        ),
        Provider<AuthRepository>(create: (_) => authRepository),
        Provider<EditProfileRepository>(create: (_) => profileRepository),
        Provider<HttpService>(create: (_) => apiService),
        ChangeNotifierProvider<RestaurantListController>(
          create: (_) => RestaurantListController(
            restaurantRepository: RestaurantListRepository(),
          ),
        ),
        ChangeNotifierProvider<ChatController>(
          create: (_) {
            final chatController = ChatController();
            globalChatController = chatController; // Set global reference
            return chatController;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        home: NavigationRouteScreen(),
      ),
    ),
  );
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationUtils().initializeFirebaseApp();
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) =>
          true;
  }
}
