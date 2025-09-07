import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iseey/AuthFlow/LoaderScreen.dart';
import 'package:iseey/generated/l10n.dart';

import 'AfterLoginFlow/Abc.dart';
import 'GlobalFiles/AppColors.dart';
import 'GlobalFiles/GlobalVariables.dart';

class NavigationRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.delegate.supportedLocales,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.mainBackgroundColorOrange)),
      home: Builder(builder: (context) {
        screenSize = MediaQuery.of(context).size;
        return LoaderScreen(isInitial: true);
      }),
    );
  }

  void redirectToTest(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Test()));
  }
}
