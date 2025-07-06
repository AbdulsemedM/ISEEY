import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class HaveAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HaveAccountButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(30, 0, 20, 20),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        child: GlobalWidgets.setText(
          L10n.current.sign_up_have_an_acccount_button_title,
          strTextColor: AppColors.strMainTextColorWhite,
          fontSize: 14,
          maxLine: 2,
        ),
      ),
    );
  }
}