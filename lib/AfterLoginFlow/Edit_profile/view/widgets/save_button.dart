import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class SaveButton extends StatelessWidget {
  final Function() onPressed;

  const SaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: GlobalWidgets.setButton(
        padding: const EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
        onPressButton: onPressed,
        textWidget: SizedBox(
          width: 125,
          child: GlobalWidgets.setText(
            L10n.current.edit_profile_save_button_title,
            textAlign: TextAlign.center,
            fontSize: 16,
            strTextColor: AppColors.strMainTextColorWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}