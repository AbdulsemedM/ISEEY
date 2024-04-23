import 'dart:ui';

class AppColors {
  static Color mainTextColorWhite = HexColor("FFFFFF");
  static Color mainTextColorBlack = HexColor("000000");
  static Color screensBackgroundsColor = HexColor("1a1d24");
  static Color mainBackgroundColorOrange = HexColor("d45501");
  static Color innerShadowColor = HexColor("000000");
  static Color tabBarBoxBackgroundColor = HexColor("191b22");
  static Color listBoxBackgroundColor = HexColor("111113");
  static Color fieldShadow = HexColor("6c6e72");
  static Color fieldsBackgroundColor = HexColor("121419");
  static Color userProfileBackground = HexColor("252a30");
  static Color textFieldUnderlineColor = HexColor("a7a6a6");

  static String strMainTextColorWhite = "FFFFFF";
  static String strMainTextColorBlack = "000000";
  static String strScreensBackgroundsColor = "1a1d24";
  static String strMainBackgroundColorOrange = "d45501";
  static String strInnerShadowColor = "000000";
  static String strFieldShadow = "6c6e72";
  static String strFieldsBackgroundColor = "121419";
  static String strUserProfileBackground = "252a30";
  static String strMainTextColorGrey = "bdbfbe";
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    if (hexColor.isEmpty) {
      hexColor = "FFFFFF";
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
