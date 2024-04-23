import 'dart:convert';

import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  callForgotPasswordApi() async {
    var data = new Map<String, dynamic>();
    data['email'] = emailController.text;
    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
        url: 'users/forgotPassword', method: RequestMethodType.POST, body: body, params: '', headerType: "json", authMethod: false);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        if (jsonRes["success"] == 200) {
          showSuccessOrFail(
            jsonRes["message"],
            jsonRes["success"],
            context,
            isTitleEnable: false,
          );
        } else {
          showSuccessOrFail(jsonRes["message"], jsonRes["success"], context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  TextEditingController emailController = TextEditingController();

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
        child: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, screenSize.width * 0.30, 0, 0),
                      width: screenSize.width * 0.6,
                      child: AspectRatio(
                        aspectRatio: 223 / 58,
                        child: Image.asset(
                          AssetsConstant.instance.logo,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Image.asset(
                        AssetsConstant.instance.pwdIcon,
                        color: AppColors.mainBackgroundColorOrange,
                        fit: BoxFit.contain,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: GlobalWidgets.setText(L10n.current.forgot_password_button_title,
                          fontSize: 22, strTextColor: AppColors.mainTextColorWhite),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GlobalWidgets.setText(
                        L10n.current.forgot_password_page_subtitle,
                        fontSize: 18,
                        textAlign: TextAlign.center,
                        strTextColor: AppColors.mainTextColorWhite,
                        maxLine: 2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 60, 30, 0),
                      child: GlobalWidgets.setTextField(
                        onTap: () {},
                        controller: emailController,
                        textCapitalization: TextCapitalization.none,
                        txtFieldHintText: L10n.current.edit_profile_example_email,
                        fontColor: AppColors.mainTextColorWhite,
                        cursorColor: AppColors.mainBackgroundColorOrange,
                        inputType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(30, 40, 20, 0),
                      child: GlobalWidgets.setButton(
                        padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
                        onPressButton: () {
                          if (emailController.text.isEmpty) {
                            return Fluttertoast.showToast(msg: L10n.current.login_empty_credentials_message);
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(emailController.text)) {
                            return Fluttertoast.showToast(msg: 'Email not valid');
                          }
                          if (emailController.text.isEmpty) {
                            GlobalWidgets.showSnackBarWithText(scaffoldKey.currentState!, "Email Field Should Not Be Empty.", "");
                          } else {
                            callForgotPasswordApi();
                          }
                        },
                        textWidget: GlobalWidgets.setText(L10n.current.forgot_password_page_button_title,
                            textAlign: TextAlign.center,
                            fontSize: 20,
                            strTextColor: AppColors.strMainTextColorWhite,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 20),
              width: 45,
              height: 45,
              alignment: Alignment.topLeft,
              child: NeumorphicButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.instance.leftArrowIcon,
                    fit: BoxFit.contain,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  depth: -3,
                  lightSource: LightSource.top,
                  color: AppColors.listBoxBackgroundColor,
                  border: NeumorphicBorder(
                    color: AppColors.innerShadowColor,
                    width: 1,
                  ),
                  shadowDarkColor: AppColors.innerShadowColor,
                  shadowLightColorEmboss: Colors.transparent,
                  shadowDarkColorEmboss: AppColors.innerShadowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
