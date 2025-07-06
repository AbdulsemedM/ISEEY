import 'package:flutter/material.dart';

class CustomNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navKey;
  final Widget widget;
  final String route;
  CustomNavigator({@required this.navKey, required this.widget, required this.route});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: "/",
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (_context) {
          return this.widget;
        });
      },
    );
  }
}

class CustomNavigatorKeys {
  Map<String, GlobalKey<NavigatorState>> keys = {};
  static CustomNavigatorKeys instance = CustomNavigatorKeys();
  static GlobalKey<NavigatorState> createOrGetKey(String routePath) {
    // init();
    return CustomNavigatorKeys.instance.keys.putIfAbsent(routePath, () => GlobalKey<NavigatorState>());
  }

  static init() {
    CustomNavigatorKeys.instance = CustomNavigatorKeys();
  }

  static Map<String, GlobalKey<NavigatorState>> getKeys() {
    //init();
    return CustomNavigatorKeys.instance.keys;
  }
}
