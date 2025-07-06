import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iseey/AuthFlow/ForgotPasswordScreen.dart';
import 'package:iseey/AuthFlow/domain/auth_repository.dart';
import 'package:iseey/AuthFlow/view/SignupScreen.dart';
import 'package:iseey/CustomTabbarController/CustomTabbarController.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogoSection(),
              _buildEmailField(),
              _buildPasswordField(),
              _buildForgotPasswordButton(),
              _buildLoginButton(authRepository),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSignUpButton(),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.4, 0, 0),
      width: screenSize.width * 0.75,
      child: AspectRatio(
        aspectRatio: 223 / 58,
        child: Image.asset(
          AssetsConstant.logo,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, screenSize.width * 0.35, 30, 0),
      child: GlobalWidgets.setTextField(
        onTap: () {},
        textCapitalization: TextCapitalization.none,
        txtFieldHintText: L10n.current.email_field_hint_text,
        controller: emailController,
        fontColor: AppColors.mainTextColorWhite,
        cursorColor: AppColors.mainBackgroundColorOrange,
        inputType: TextInputType.emailAddress,
        prefixIconWidth: 25,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: GlobalWidgets.setTextField(
        onTap: () {},
        controller: passwordController,
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

  Widget _buildForgotPasswordButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 20, 0),
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

  Widget _buildLoginButton(AuthRepository authRepository) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(30, 0, 20, 40),
      child: GlobalWidgets.setButton(
        padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
        onPressButton: () {
          _validateAndLogin(authRepository);
        },
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

  Widget _buildSignUpButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(30, 0, 20, 20),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            SlideLeftRoute(
              page: SignupScreen(),
              routeName: "/signup",
            ),
          );
        },
        child: GlobalWidgets.setText(
          L10n.current.login_sign_up_button_title,
          strTextColor: AppColors.strMainTextColorWhite,
          fontSize: 16,
        ),
      ),
    );
  }

  void _validateAndLogin(AuthRepository authRepository) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: L10n.current.login_empty_credentials_message);
      return;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      Fluttertoast.showToast(msg: L10n.current.email_not_valid_error_message);
      return;
    }

    try {
      await authRepository.login(
        emailController.text,
        passwordController.text,
        scaffoldKey,
        context,
      );
      _navigateToOnBoardingScreen();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  void _navigateToOnBoardingScreen() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: CustomTabBarController(
          key: customTabBarControllerKey,
        ),
        routeName: "/tabBarController",
      ),
    );
  }
}
