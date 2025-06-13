import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/controller/restaurant_list_controller.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/domain/restaurant_list_repository.dart';
import 'package:iseey/AuthFlow/domain/auth_repository.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/domain/Edit_profile_repository.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/Services/notification_utils.dart';
import 'package:provider/provider.dart';
import 'package:iseey/Services/ApiService.dart';
import 'NavigationRouteScreen.dart';
import 'Services/StateManagement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationUtils().initializeFirebaseApp();
  FirebaseMessaging.onBackgroundMessage(
    (message) async => await _firebaseMessagingBackgroundHandler(message),
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        home: NavigationRouteScreen(),
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
      ..badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) =>
          true;
  }
}
