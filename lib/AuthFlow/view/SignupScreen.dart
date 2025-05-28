import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/screens/EditProfileScreen.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:provider/provider.dart';
import 'package:iseey/AuthFlow/domain/auth_repository.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart'; 
import 'widgets/logo_section.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/terms_checkbox.dart';
import 'widgets/signup_button.dart';
import 'widgets/have_account_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const LogoSection(),
                CustomTextField(
                  controller: firstNameController,
                  hintText: L10n.current.edit_profile_example_first_name,
                  labelText: L10n.current.sign_up_first_name_text_field_title,
                  prefixIcon: AssetsConstant.userIcon,
                  validator: (value) => value?.isEmpty ?? true ? "First name required" : null,
                ),
                CustomTextField(
                  controller: lastNameController,
                  hintText: L10n.current.edit_profile_example_last_name,
                  labelText: L10n.current.sign_up_last_name_text_field_title,
                  prefixIcon: AssetsConstant.userIcon,
                  validator: (value) => value?.isEmpty ?? true ? "Last name required" : null,
                ),
                CustomTextField( prefixIcon: AssetsConstant.email,
                  controller: emailController,
                  hintText: L10n.current.email_field_hint_text,
                  labelText: L10n.current.sign_up_email_text_field_title,
                  inputType: TextInputType.emailAddress,
                  validator: (value) => value?.isEmpty ?? true ? "Email required" : null,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "",
                  labelText: L10n.current.password_field_hint_text,
                  prefixIcon: AssetsConstant.pwdIcon,
                  obscureText: true,
                  validator: (value) => value?.isEmpty ?? true ? "Password required" : null,
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "",
                  labelText: L10n.current.sign_up_confirm_password_text_field_title,
                  prefixIcon: AssetsConstant.pwdIcon,
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return "Confirm password required";
                    if (value != passwordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                TermsCheckbox(
                  onChanged: (value) => setState(() => isAgree = value),
                ),
                SignupButton(
                  onPressed: () => _validateAndSignup(authRepository),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HaveAccountButton(
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _validateAndSignup(AuthRepository authRepository) async {
  if (_formKey.currentState!.validate() && isAgree) {
    try {
      await authRepository.signup(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        scaffoldKey: scaffoldKey,
        context: context,
      );

      Navigator.push(
        context,
        SlideLeftRoute(
          page: EditProfileScreen(
            isFromSignUp: true,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
          ),
          routeName: "/editProfile",
        ),
      );
    } catch (e) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        e.toString(),
        "",
      );
    }
  } else {
    GlobalWidgets.showSnackBarWithText(
      scaffoldKey.currentState!,
      "Please fill all fields and agree to the terms.",
      "",
    );
  }
}
}