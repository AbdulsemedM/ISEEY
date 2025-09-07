import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/chat/controller/chat_controller.dart';
import 'package:iseey/CustomTabbarController/CustomTabbarController.dart';

import 'GlobalWidgets.dart';

final googleApiKey = "AIzaSyBbWyDKikhzUc2YsOShB35gb5n-UcgqJXs";
late Size screenSize;
String strSup = "\u002A";
bool inActivateBottomBar = false;
int currentSelectedTab = 1;
int selectedMenuItemIndex = -1;
String? selectedRestaurantId;

String profileImgUrl = '';
String fcmRegistrationToken = "";
String? globalChatUserId;
ChatController? globalChatController; // Global chat controller reference
var globalWidget = GlobalWidgets();
GlobalKey<ScaffoldState> mainTabsScaffoldKey = new GlobalKey<ScaffoldState>();
GlobalKey<NavigatorState> mainNavKey = new GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

GlobalKey<CustomTabBarControllerState> customTabBarControllerKey = GlobalKey();

bottomBarActiveSelection(bool isActive) {
  if (isActive) {
    inActivateBottomBar = false;
  } else {
    inActivateBottomBar = true;
  }
}
