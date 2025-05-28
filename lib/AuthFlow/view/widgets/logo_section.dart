import 'package:flutter/material.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.4, 0, 0),
      width: screenSize.width * 0.75,
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