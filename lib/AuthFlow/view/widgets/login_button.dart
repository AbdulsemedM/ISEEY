import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(30, 0, 20, 40),
      child: GlobalWidgets.setButton(
        padding: const EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
        onPressButton: onPressed,
        textWidget: GlobalWidgets.setText(
          L10n.current.login_button_title,
          textAlign: TextAlign.center,
          fontSize: 20,
          strTextColor: AppColors.strMainTextColorWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}