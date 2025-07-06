import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, screenSize.width * 0.35, 30, 0),
      child: GlobalWidgets.setTextField(
        onTap: () {},
        textCapitalization: TextCapitalization.none,
        txtFieldHintText: L10n.current.email_field_hint_text,
        controller: controller,
        fontColor: AppColors.mainTextColorWhite,
        cursorColor: AppColors.mainBackgroundColorOrange,
        inputType: TextInputType.emailAddress,
        prefixIconWidth: 25,
      ),
    );
  }
}