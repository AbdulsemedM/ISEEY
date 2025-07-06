import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class DeleteAccountButton extends StatelessWidget {
  final Function() onPressed;

  const DeleteAccountButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6.0),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 160,
          child: GlobalWidgets.setText(
            L10n.current.edit_profile_delete_account_button_title,
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