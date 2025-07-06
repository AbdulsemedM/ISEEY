import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FormFieldValidator<String>? firstNameValidator;
  final FormFieldValidator<String>? lastNameValidator;
  final FormFieldValidator<String>? emailValidator;
  final FormFieldValidator<String>? passwordValidator;
  final FormFieldValidator<String>? confirmPasswordValidator;

  const SignupForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.firstNameValidator,
    this.lastNameValidator,
    this.emailValidator,
    this.passwordValidator,
    this.confirmPasswordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: GlobalWidgets.setTextField(
            onTap: () {},
            controller: firstNameController,
            fontColor: AppColors.mainTextColorWhite,
            cursorColor: AppColors.mainBackgroundColorOrange,
            txtFieldHintText: L10n.current.edit_profile_example_first_name,
            txtFieldLabelText: L10n.current.sign_up_first_name_text_field_title,
            strPrefixAssetImageName: AssetsConstant.userIcon,
            prefixIconWidth: 20,
            inputType: TextInputType.name,
            validator: firstNameValidator,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: GlobalWidgets.setTextField(
            onTap: () {},
            controller: lastNameController,
            fontColor: AppColors.mainTextColorWhite,
            txtFieldHintText: L10n.current.edit_profile_example_last_name,
            cursorColor: AppColors.mainBackgroundColorOrange,
            txtFieldLabelText: L10n.current.sign_up_last_name_text_field_title,
            strPrefixAssetImageName: AssetsConstant.userIcon,
            prefixIconWidth: 20,
            inputType: TextInputType.name,
            validator: lastNameValidator,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: GlobalWidgets.setTextField(
            onTap: () {},
            controller: emailController,
            txtFieldLabelText: L10n.current.sign_up_email_text_field_title,
            fontColor: AppColors.mainTextColorWhite,
            txtFieldHintText: L10n.current.email_field_hint_text,
            prefixIconWidth: 25,
            cursorColor: AppColors.mainBackgroundColorOrange,
            margin: EdgeInsets.fromLTRB(10, 15, 20, 15),
            inputType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            validator: emailValidator,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: GlobalWidgets.setTextField(
            onTap: () {},
            controller: passwordController,
            fontColor: AppColors.mainTextColorWhite,
            cursorColor: AppColors.mainBackgroundColorOrange,
            strPrefixAssetImageName: AssetsConstant.pwdIcon,
            txtFieldLabelText: L10n.current.password_field_hint_text,
            prefixIconWidth: 20,
            txtFieldHintText: "",
            obscureText: true,
            inputType: TextInputType.text,
            validator: passwordValidator,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
          child: GlobalWidgets.setTextField(
            onTap: () {},
            controller: confirmPasswordController,
            fontColor: AppColors.mainTextColorWhite,
            cursorColor: AppColors.mainBackgroundColorOrange,
            strPrefixAssetImageName: AssetsConstant.pwdIcon,
            txtFieldLabelText: L10n.current.sign_up_confirm_password_text_field_title,
            prefixIconWidth: 20,
            txtFieldHintText: "",
            obscureText: true,
            inputType: TextInputType.text,
            validator: confirmPasswordValidator,
          ),
        ),
      ],
    );
  }
}