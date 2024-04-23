import 'package:ISEEY/AuthFlow/LoaderScreen.dart';
import 'package:ISEEY/Services/SocketUtils.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'AppColors.dart';
import 'GlobalVariables.dart';

class GlobalWidgets {
  static SocketUtils socketUtils = SocketUtils();

  static initSocket() {
    socketUtils = SocketUtils();
  }

  static showSnackBarWithText(
    ScaffoldState scaffoldState,
    String? strText,
    String? labelText, {
    int displayDuration = 4,
  }) {
    final snackBar = SnackBar(
      backgroundColor: AppColors.mainBackgroundColorOrange,
      content: setText(
        strText,
        textAlign: TextAlign.left,
        strTextColor: AppColors.strMainTextColorWhite,
        fontWeight: FontWeight.w700,
      ),
      action: SnackBarAction(
        label: labelText ?? '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      duration: Duration(seconds: displayDuration),
    );
    ScaffoldMessenger.of(scaffoldState.context).showSnackBar(snackBar);
  }

  static Widget setText(
    String? strText, {
    TextAlign? textAlign = TextAlign.left,
    dynamic strTextColor = "000000",
    String? strTextFontFamily = "Poppins",
    double? fontSize = 14,
    double? fontHeight = 1.0,
    double? fontLetterSpacing = 0.0,
    TextDecoration? decoration,
    FontWeight? fontWeight = FontWeight.normal,
    int? maxLine = 1,
    TextOverflow? overflow = TextOverflow.ellipsis,
  }) {
    return Text(
      strText ?? '',
      textAlign: textAlign,
      maxLines: maxLine,
      softWrap: true,
      overflow: overflow,
      style: TextStyle(
        color: strTextColor.runtimeType == String ? HexColor(strTextColor) : strTextColor,
        fontFamily: strTextFontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: fontHeight,
        decoration: decoration,
        letterSpacing: fontLetterSpacing,
      ),
    );
  }

  static Widget setTextField({
    bool isPrefixIconEnable = true,
    String strPrefixAssetImageName = "assets/email.png",
    String txtFieldLabelText = "Email",
    String txtFieldHintText = "xyz@gmail.com",
    double prefixIconHeight = 20,
    double prefixIconWidth = 20,
    EdgeInsets prefixIconMargin = EdgeInsets.zero,
    String fontFamily = "Poppins",
    double fontSize = 16,
    int? maxLines,
    FontWeight fontWeight = FontWeight.normal,
    Color fontColor = Colors.red,
    bool obscureText = false,
    TextEditingController? controller,
    Color cursorColor = Colors.red,
    bool enabled = true,
    Function(String)? validator,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? contentPadding,
    FocusNode? focusNode,
    VoidCallback? onTap,
    TextInputType? inputType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.words,
  }) {
    return TextFormField(
      textCapitalization: textCapitalization,
      keyboardType: inputType,
      obscureText: obscureText,
      controller: controller,
      cursorColor: cursorColor,
      focusNode: focusNode,
      enabled: enabled,
      onTap: onTap,
      maxLines: obscureText ? 1 : maxLines,
      validator: (value) => validator!(value!),
      style: TextStyle(
        color: fontColor,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: isPrefixIconEnable
            ? Container(
                margin: margin ?? EdgeInsets.fromLTRB(10, 10, 20, 5),
                child: strPrefixAssetImageName == 'location'
                    ? Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      )
                    : Padding(
                        padding: prefixIconMargin,
                        child: Image(
                          image: AssetImage(strPrefixAssetImageName),
                          fit: BoxFit.contain,
                          height: prefixIconHeight,
                          width: prefixIconWidth,
                        ),
                      ),
              )
            : null,
        labelText: txtFieldLabelText,
        hintText: txtFieldHintText,
        hintStyle: TextStyle(
          color: AppColors.fieldShadow,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        labelStyle: TextStyle(
          color: AppColors.mainTextColorWhite,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        errorStyle: TextStyle(
          color: AppColors.mainBackgroundColorOrange,
          fontFamily: fontFamily,
          fontSize: fontSize - 2,
          height: 1.0,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.mainBackgroundColorOrange,
            width: 1.5,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.mainBackgroundColorOrange,
            width: 1.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textFieldUnderlineColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  static Widget setButton(
      {onPressButton,
      bool? isGradientEnable = false,
      bool? isShadowEnable = false,
      double elevation = 0,
      double depth = -5,
      String strButtonColor = "d45501",
      String? strGradientColor1 = "4D54E1",
      String? strGradientColor2 = "323EB7",
      EdgeInsets? margin = EdgeInsets.zero,
      String? strColor = "4D54E1",
      BorderRadiusGeometry? borderRadius = BorderRadius.zero,
      double? buttonHeight = 45,
      Widget? textWidget,
      EdgeInsets? padding}) {
    return NeumorphicButton(
        margin: margin,
        onPressed: () => onPressButton(),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          color: HexColor(strButtonColor),
          depth: depth,
          lightSource: LightSource.top,
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColor: Colors.transparent,
          shadowLightColorEmboss: Colors.transparent,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 0.1,
          ),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
        ),
        padding: padding ?? EdgeInsets.all(12.0),
        child: textWidget);
  }

  OverlayEntry? overlayEntry;

  showLoading(BuildContext context, {bool isDismissEnable = true}) {
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        child: GestureDetector(
          onTap: () {
            if (isDismissEnable) {
              if (overlayEntry != null) {
                overlayEntry?.remove();
                overlayEntry = null;
              }
            }
          },
          child: Container(
              width: screenSize.width,
              height: screenSize.height,
              color: AppColors.screensBackgroundsColor,
              child: LoaderScreen(
                isInitial: false,
              )),
        ),
      ),
    );

    if (overlayEntry != null) {
      overlayState.insert(overlayEntry!);
    }
  }

  showPopUpWithMessage({
    required BuildContext context,
    bool? isCustomMessageIcon = false,
    bool isTitleEnable = true,
    Widget? customIcon,
    String? titleMessage,
    String message = "",
    
    String iconAssetPath = "assets/successIcon.png",
    bool conditionButtonEnable = false,
    bool withTextField = false,
    VoidCallback? onPressOKButton,
    String? btnName = "Ok",
  }) {
    titleMessage = titleMessage == null ? L10n.current.login_success_title : titleMessage;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: AppColors.screensBackgroundsColor,
            child: Center(
                child: Container(
              width: screenSize.width - 40,
              height: screenSize.height * 0.56,
              child: Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  depth: -3,
                  lightSource: LightSource.top,
                  color: AppColors.tabBarBoxBackgroundColor,
                  border: NeumorphicBorder(
                    color: AppColors.innerShadowColor,
                    width: 1,
                  ),
                  shadowDarkColor: AppColors.innerShadowColor,
                  shadowLightColorEmboss: Colors.transparent,
                  shadowDarkColorEmboss: AppColors.innerShadowColor,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Image.asset(
                              iconAssetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                          if (isTitleEnable)
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: GlobalWidgets.setText(
                                titleMessage,
                                strTextColor: AppColors.strMainTextColorWhite,
                                textAlign: TextAlign.center,
                                fontSize: 26,
                                fontHeight: 2,
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: GlobalWidgets.setText(
                              message,
                              strTextColor: AppColors.strMainTextColorWhite,
                              textAlign: TextAlign.center,
                              maxLine: 4,
                              fontSize: 20,
                            ),
                          ),
                          if (withTextField)
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                top: 35,
                                right: 20,
                                bottom: 20,
                              ),
                              height: 100,
                              child: Neumorphic(
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(0),
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: -2,
                                  lightSource: LightSource.top,
                                  color: AppColors.screensBackgroundsColor,
                                  border: NeumorphicBorder(
                                    color: AppColors.innerShadowColor,
                                    width: 0.1,
                                  ),
                                  intensity: 0.75,
                                  shadowDarkColor: AppColors.innerShadowColor,
                                  shadowLightColorEmboss: Colors.transparent,
                                  shadowDarkColorEmboss: AppColors.innerShadowColor,
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: TextField(
                                      keyboardAppearance: Brightness.dark,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: AppColors.mainTextColorWhite,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.mainBackgroundColorOrange,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          conditionButtonEnable
                              ? Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 15),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          child: GlobalWidgets.setButton(
                                            onPressButton: () {
                                              if (overlayEntry != null) {
                                                overlayEntry?.remove();
                                                overlayEntry = null;
                                              }
                                              return onPressOKButton!();
                                            },
                                            textWidget: Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: GlobalWidgets.setText(
                                                L10n.current.accept_button_title,
                                                textAlign: TextAlign.center,
                                                fontSize: 16,
                                                strTextColor: AppColors.strMainTextColorWhite,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(width: 15),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          child: GlobalWidgets.setButton(
                                            strButtonColor: "c8c8c8",
                                            onPressButton: () {
                                              if (overlayEntry != null) {
                                                overlayEntry?.remove();
                                                overlayEntry = null;
                                              }
                                            },
                                            textWidget: Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: GlobalWidgets.setText(
                                                L10n.current.cancel_button_title,
                                                textAlign: TextAlign.center,
                                                fontSize: 16,
                                                strTextColor: HexColor("1c1c1c"),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(width: 15),
                                    ],
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(30, 50, 20, 0),
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.only(top: 6, bottom: 6),
                                    child: GlobalWidgets.setButton(
                                      onPressButton: () {
                                        if (overlayEntry != null) {
                                          overlayEntry?.remove();
                                          overlayEntry = null;
                                        }
                                        return onPressOKButton!();
                                      },
                                      depth: -3,
                                      textWidget: Container(
                                        alignment: Alignment.center,
                                        child: GlobalWidgets.setText(
                                          btnName,
                                          textAlign: TextAlign.center,
                                          fontSize: 20,
                                          strTextColor: AppColors.strMainTextColorWhite,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );

    if (overlayEntry != null) {
      overlayState.insert(overlayEntry!);
    }
  }

  static final RegExp regexEmoji = RegExp(
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
  );

  static Widget buildChatMsgContent(String? content) {
    final Iterable<Match> matches = regexEmoji.allMatches(content!);
    if (matches.isEmpty)
      return GlobalWidgets.setText(
        '${content.trim()}',
        strTextColor: AppColors.strMainTextColorWhite,
        fontSize: 15,
        fontHeight: 1.5,
        maxLine: 100,
      );

    return RichText(
      text: TextSpan(
        children: [
          for (var t in content.trim().characters)
            TextSpan(
              text: t,
              style: TextStyle(
                fontSize: regexEmoji.allMatches(t).isNotEmpty ? 24.0 : 15.0,
                fontFamily: 'Poppins',
                color: HexColor(AppColors.strMainTextColorWhite),
              ),
            ),
        ],
      ),
    );
  }

  hideLoading() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
