import 'package:ISEEY/CustomTabbarController/CustomTabbarController.dart';
import 'package:flutter/material.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}
class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.push(
          context,
          SlideLeftRoute(
            page: CustomTabBarController(
              key: customTabBarControllerKey,
              fromChat: 2,
            ),
            routeName: "/tabBarController",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainTabsScaffoldKey,
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
