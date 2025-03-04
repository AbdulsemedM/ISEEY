import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iseey/AuthFlow/LoginScreen.dart';
import 'package:iseey/CustomTabbarController/CustomTabbarController.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoaderScreen extends StatefulWidget {
  final bool isInitial;
  final bool? notify;

  LoaderScreen({Key? key, required this.isInitial, this.notify = false}) : super(key: key);

  @override
  _LoaderScreenState createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isInitial) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        sendLoginScreen();
      });
    }
  }

  sendLoginScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isFromLogin = prefs.getBool("isFromLogin") ?? false;
    String? languageCode = Platform.localeName.split('_')[0];
    prefs.setString("languageCode", languageCode);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isFromLogin) {
        Navigator.push(
          context,
          SlideLeftRoute(
            page: CustomTabBarController(
              key: customTabBarControllerKey,
            ),
            routeName: "/tabBarController",
          ),
        );
      } else {
        Navigator.push(
          context,
          SlideLeftRoute(
            page: LoginScreen(),
            routeName: "/login",
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screensBackgroundsColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: GlobalWidgets.setText(L10n.current.loading_title,
                  strTextColor: AppColors.strMainTextColorWhite, fontSize: 16),
            ),
            CollectionSlideTransition(
              children: <Widget>[
                Container(),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                  child: Icon(
                    Icons.circle,
                    color: AppColors.mainBackgroundColorOrange,
                    size: 15,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                  child: Icon(
                    Icons.circle,
                    color: AppColors.mainBackgroundColorOrange,
                    size: 15,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                  child: Icon(
                    Icons.circle,
                    color: AppColors.mainBackgroundColorOrange,
                    size: 15,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Icon(
                    Icons.circle,
                    color: AppColors.mainBackgroundColorOrange,
                    size: 15,
                  ),
                ),
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
