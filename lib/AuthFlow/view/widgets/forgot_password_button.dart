import 'package:flutter/material.dart';
import 'package:iseey/AuthFlow/ForgotPasswordScreen.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/generated/l10n.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 20, 0),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            SlideLeftRoute(
              page: ForgotPasswordScreen(),
              routeName: "/forgotPassword",
            ),
          );
        },
        child: GlobalWidgets.setText(
          L10n.current.forgot_password_button_title,
          strTextColor: AppColors.strMainTextColorWhite,
          fontSize: 16,
        ),
      ),
    );
  }
}