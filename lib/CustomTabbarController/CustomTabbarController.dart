import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseey/AfterLoginFlow/Restaurant/view/restaurant_screen.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/controller/restaurant_list_controller.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/view/screens/RestaurantList.dart';
import 'package:iseey/AuthFlow/domain/auth_repository.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/Services/SocketUtils.dart';
import 'package:iseey/Services/menu.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/CustomTabbarController/CustomBottomNavigationBar.dart';
import 'package:iseey/Drawer/DrawerScreen.dart';
import 'package:iseey/AfterLoginFlow/ChatPartnerScreen.dart';
import 'package:provider/provider.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'CustomNavigator.dart';

class CustomTabBarController extends StatefulWidget {
  final int? fromChat;

  CustomTabBarController({
    Key? key,
    this.fromChat = 1,
  }) : super(key: key);

  @override
  CustomTabBarControllerState createState() => CustomTabBarControllerState();
}

class CustomTabBarControllerState extends State<CustomTabBarController> {
  int? selectedIndex = inActivateBottomBar ? -1 : currentSelectedTab;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> bottomTabs = ["/tab1", "/tab2", "/tab3"];
  SocketUtils socketUtils = SocketUtils.instance;

  // Create a listen of the websocket events using this event `receiveMessage`
  void listenToChatMessages() {
    socketUtils.socket.on('receiveMessage', (data) {
      // Handle incoming chat messages
      print("New chat message received: $data");
    });
  }

  void updateDetails() {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    authRepository.updateDeviceDetails(scaffoldKey);
  }

  // this method updates the user current location every 30 seconds
  void startLocationUpdateTimer() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      if(selectedRestaurantId == null){
        return;
      }
      _updateUserLocation();
    });
  }

  void _updateUserLocation() async {
    try {
      final authRepository =
          Provider.of<AuthRepository>(context, listen: false);
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await authRepository.updateUserCurrentLocation(
        scaffoldKey: scaffoldKey,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    initSocket();
    updateDetails();
    // listenToChatMessages();
    startLocationUpdateTimer();
    context.read<RestaurantListController>().loadRestaurantList(
          context: context,
          scaffoldKey: scaffoldKey,
        );
    if (widget.fromChat == 2) {
      currentSelectedTab = 2;
      selectedMenuItemIndex = 0;
    } else {
      currentSelectedTab = 1;
      selectedMenuItemIndex = 0;
    }
    super.initState();
  }

  Future<void> initSocket() async {
    await socketUtils.connectSocket();
    socketUtils.setOnChatMessageReceivedListener((value) {});
    socketUtils.setConnectListener((value) {});
    socketUtils.setOnDisconnectListener((value) {});
    socketUtils.setOnCustomErrorListener((value) {});
    socketUtils.setOnConnectionErrorListener((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: mainTabsScaffoldKey,
        backgroundColor: AppColors.screensBackgroundsColor,
        body: Stack(
          children: <Widget>[
            offStateNavigator(routePath: "/tab1", widget: RestaurantScreen()),
            offStateNavigator(routePath: "/tab2", widget: RestaurantList()),
            offStateNavigator(routePath: "/tab3", widget: ChatPartnerScreen()),
          ],
        ),
        drawer: setDrawer(),
        bottomNavigationBar: setBottomBar(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (BuildContext _) {
            return AlertDialog(
              title: Text(L10n.current.are_you_sure_message),
              content: Text(L10n.current.app_logout_warning_message),
              actions: <Widget>[
                MaterialButton(
                  child: Text(L10n.current.decline_button_title),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                MaterialButton(
                  child: Text(L10n.current.accept_button_title),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  setDrawer() {
    return DrawerScreen(
      scaffoldKey: mainTabsScaffoldKey,
    );
  }

  Widget offStateNavigator({
    required Widget widget,
    required String routePath,
    GlobalKey<NavigatorState>? navKey,
  }) {
    String currentRoutePath = bottomTabs[currentSelectedTab];

    return Offstage(
      offstage: currentRoutePath != routePath,
      child: CustomNavigator(
        navKey: navKey ?? CustomNavigatorKeys.createOrGetKey(routePath),
        widget: widget,
        route: routePath,
      ),
    );
  }

  bool isConditionTrue() {
    if (selectedRestaurantId == null && currentSelectedTab == 0) {
      return false;
    } else {
      return true;
    }
  }

  setBottomBar() {
    return CustomBottomNavyBar(
      selectedIndex: currentSelectedTab,
      items: bottomNavItems,
      onItemSelected: (index) => onBottomTabClick(index),
    );
  }

  openChat() {
    Future.delayed(const Duration(milliseconds: 500), () {
      selectedMenuItemIndex = 0;
      onBottomTabClick(2);
    });
  }

  onBottomTabClick(index) {
    setState(() {
      currentSelectedTab = index;
      selectedIndex = index;

      if (index == 2) {
        Provider.of<StateManagement>(
                mainTabsScaffoldKey.currentContext ?? context,
                listen: false)
            .reloadBuild();
      }

      if (!isConditionTrue()) {
        currentSelectedTab = 1;
        showSuccessOrFail(
          L10n.current.no_restaurant_selected_error_message,
          false,
          context,
          isCustom: true,
          onCustomOkPress: () => setState(() => currentSelectedTab = 1),
        );
        return;
      } else {
        if (index == 0) {
          Provider.of<StateManagement>(
                  mainTabsScaffoldKey.currentContext ?? context,
                  listen: false)
              .reloadRestaurantBuild();
        }
      }

      if (currentSelectedTab == 1) {
        selectedMenuItemIndex = 0;
      } else {
        selectedMenuItemIndex = -1;
      }
    });
  }
}
