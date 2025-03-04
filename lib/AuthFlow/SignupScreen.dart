import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/UserModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditProfileScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isAgree = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() async {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      await callSignupApi();
    } else {
      debugPrint('Form is invalid');
    }
  }

  Future<void> callSignupApi() async {
    if (!isAgree) {
      return globalWidget.showPopUpWithMessage(
        context: context,
        titleMessage: L10n.current.sign_up_terms_agreement_warning_title,
        message: L10n.current.sign_up_terms_agreement_warning_message,
        onPressOKButton: () => debugPrint("OK Pressed"),
      );
    }

    var data = new Map<String, dynamic>();
    data['first_name'] = firstNameController.text;
    data['last_name'] = lastNameController.text;
    data['email'] = emailController.text;
    data['password'] = passwordController.text;
    data['device_token'] = fcmRegistrationToken;
    data['device_type'] = Platform.isIOS ? 'ios' : 'android';

    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
      url: 'users/signup',
      method: RequestMethodType.POST,
      body: body,
      params: '',
      headerType: "json",
      authMethod: false,
    );
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != "") {
        var jsonRes = jsonDecode(response);

        UserModel user = UserModel.fromJson(jsonRes);
        if (user.success == 200) {
          saveResponse(user.result?.token ?? '', user.result);
          showSuccessOrFail(user.message, user.success);
        } else {
          showSuccessOrFail(user.message, user.success);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000);
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
    }
  }

  showSuccessOrFail(String message, int statusCode) {
    if (statusCode == 200) {
      return globalWidget.showPopUpWithMessage(
        context: context,
        message: message,
        onPressOKButton: () {
          Navigator.push(
              context,
              SlideLeftRoute(
                routeName: '/editProfile',
                page: EditProfileScreen(isFromSignUp: true),
              ));
        },
      );
    } else {
      return globalWidget.showPopUpWithMessage(
        context: context,
        titleMessage: L10n.current.sign_up_failure_message_title,
        iconAssetPath: AssetsConstant.errorIcon,
        message: message,
        onPressOKButton: () => print("OK Pressed"),
      );
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.2, 0, 30),
                    width: screenSize.width * 0.65,
                    child: AspectRatio(
                      aspectRatio: 223 / 58,
                      child: Image.asset(
                        AssetsConstant.logo,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
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
                      validator: (value) {
                        if (value.length == 0) {
                          return "      " + L10n.current.sign_up_first_name_required_error + strSup;
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value.length == 0) {
                          return "      " + L10n.current.sign_up_last_name_required_error + strSup;
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value.length == 0) {
                          return "      " + L10n.current.sign_up_email_required_error + strSup;
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value.length == 0) {
                          return "      " + L10n.current.sign_up_password_required_error + strSup;
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value.length == 0) {
                          return "      " + L10n.current.sign_up_confirm_password_required_error + strSup;
                        }

                        if (value != passwordController.text) {
                          return "      " + L10n.current.sign_up_passwords_not_equal + strSup;
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 0, 10),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: AppColors.mainTextColorWhite,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAgree = !isAgree;
                          });
                        },
                        child: Row(
                          children: [
                            isAgree
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      AssetsConstant.selectedCheckbox,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      AssetsConstant.unselectedCheckbox,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text.rich(
                                  TextSpan(
                                    text: L10n.current.sign_up_terms_of_use_agreement_text + ' ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                      color: AppColors.mainTextColorWhite,
                                    ),
                                    children: <WidgetSpan>[
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              FocusScope.of(context).unfocus();
                                              launchURL("https://iseey.app/privacy/");
                                            });
                                          },
                                          child: GlobalWidgets.setText(
                                            L10n.current.sign_up_terms_of_use_title,
                                            textAlign: TextAlign.left,
                                            strTextColor: AppColors.strMainTextColorWhite,
                                            fontSize: 15,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(30, 10, 20, 40),
                    child: GlobalWidgets.setButton(
                      padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
                      onPressButton: () {
                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          return Fluttertoast.showToast(
                              msg: L10n.current.sign_up_email_and_password_is_empty_error_message);
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text)) {
                          return Fluttertoast.showToast(msg: L10n.current.email_is_not_valid_error_message);
                        }
                        validateAndSave();
                      },
                      textWidget: GlobalWidgets.setText(
                        L10n.current.signup_button_title,
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
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(30, 0, 20, 20),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: GlobalWidgets.setText(
            L10n.current.sign_up_have_an_acccount_button_title,
            strTextColor: AppColors.strMainTextColorWhite,
            fontSize: 14,
            maxLine: 2,
          ),
        ),
      ),
    );
  }
}
