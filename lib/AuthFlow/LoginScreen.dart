import 'dart:convert';
import 'dart:io';

import 'package:ISEEY/AuthFlow/ForgotPasswordScreen.dart';
import 'package:ISEEY/AuthFlow/SignupScreen.dart';
import 'package:ISEEY/CustomTabbarController/CustomTabbarController.dart';
import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/UserModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if (mounted) setState(() {});
  }

  callLoginApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    if (emailController.text.isEmpty) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.empty_email_adress_error_message,
        "",
      );
      return null;
    }

    if (!isValidateEmail(emailController.text)) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.invalid_email_adress_error_message,
        "",
      );
      return null;
    }

    if (passwordController.text.isEmpty) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.incorrect_email_adress_error_message,
        "",
      );
      return null;
    } else if (passwordController.text.length < 8) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.password_length_error_message,
        "",
      );
      return null;
    }

    var data = new Map<String, dynamic>();

    data['email'] = emailController.text;
    data['password'] = passwordController.text;
    data['device_token'] = fcmRegistrationToken;
    data['device_type'] = Platform.isIOS ? 'ios' : 'android';
    var body = json.encode(data);
    HttpRequestModel req = new HttpRequestModel(
      url: 'users/login',
      method: RequestMethodType.POST,
      params: '',
      body: body,
      headerType: "json",
      authMethod: false,
    );
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        UserModel user = UserModel.fromJson(jsonRes);
        if (user.success == 200) {
          saveResponse(user.result?.token ?? '', user.result);
        } else {
          showSuccessOrFail(user.message, user.success, context);
        }
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  void saveResponse(token, UserResult? userInfo) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isFromLogin", true);
      prefs.setString("token", token);

      storeMapData("userdata", userInfo);
      _navigateToOnBoardingScreen();
    }
  }

  _navigateToOnBoardingScreen() {
    return Navigator.push(
      context,
      SlideLeftRoute(
        page: CustomTabBarController(
          key: customTabBarControllerKey,
        ),
        routeName: "/tabBarController",
      ),
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.4, 0, 0),
                  width: screenSize.width * 0.75,
                  child: AspectRatio(
                    aspectRatio: 223 / 58,
                    child: Image.asset(
                      AssetsConstant.instance.logo,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
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
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: GlobalWidgets.setTextField(
                    onTap: () {},
                    controller: passwordController,
                    fontColor: AppColors.mainTextColorWhite,
                    cursorColor: AppColors.mainBackgroundColorOrange,
                    strPrefixAssetImageName: AssetsConstant.instance.pwdIcon,
                    prefixIconWidth: 20,
                    txtFieldLabelText: L10n.current.password_field_hint_text,
                    txtFieldHintText: "",
                    inputType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
                Container(
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
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(30, 0, 20, 40),
                  child: GlobalWidgets.setButton(
                    padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
                    onPressButton: () {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        return Fluttertoast.showToast(msg: L10n.current.login_empty_credentials_message);
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)) {
                        return Fluttertoast.showToast(msg: L10n.current.email_not_valid_error_message);
                      }
                      callLoginApi(scaffoldKey);
                    },
                    textWidget: GlobalWidgets.setText(
                      L10n.current.login_button_title,
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      strTextColor: AppColors.strMainTextColorWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }
}
