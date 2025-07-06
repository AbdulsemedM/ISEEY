import 'package:flutter/material.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';

class SignupLogo extends StatelessWidget {
  const SignupLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.2, 0, 30),
      width: screenSize.width * 0.65,
      child: AspectRatio(
        aspectRatio: 223 / 58,
        child: Image.asset(
          AssetsConstant.logo,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}