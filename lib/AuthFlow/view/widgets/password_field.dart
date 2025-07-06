import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  
  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: GlobalWidgets.setTextField(
        onTap: () {},
        controller: controller,
        fontColor: AppColors.mainTextColorWhite,
        cursorColor: AppColors.mainBackgroundColorOrange,
        strPrefixAssetImageName: AssetsConstant.pwdIcon,
        prefixIconWidth: 20,
        txtFieldLabelText: L10n.current.password_field_hint_text,
        txtFieldHintText: "",
        inputType: TextInputType.text,
        obscureText: true,
      ),
    );
  }
}