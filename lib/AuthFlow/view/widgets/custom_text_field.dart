import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String prefixIcon;
  final double prefixIconWidth;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.prefixIconWidth = 20,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 15, 30, 0),
      child: GlobalWidgets.setTextField(
        onTap: onTap,
        controller: controller,
        fontColor: AppColors.mainTextColorWhite,
        cursorColor: AppColors.mainBackgroundColorOrange,
        txtFieldHintText: hintText,
        txtFieldLabelText: labelText,
        strPrefixAssetImageName: prefixIcon,
        prefixIconWidth: prefixIconWidth,
        inputType: inputType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}