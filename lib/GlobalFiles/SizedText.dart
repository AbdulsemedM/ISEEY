import 'package:flutter/material.dart';

import 'AppColors.dart';
import 'GlobalWidgets.dart';

class SizedText {
  final String text;
  final TextAlign? textAlign;
  final String strTextColor;
  final String? strTextFontFamily;
  final double fontSize;
  final double? fontHeight;
  final double? fontLetterSpacing;
  final FontWeight? fontWeight;
  final int? maxLine;
  final double textWidth;
  final BuildContext context;

  SizedText({
    required this.text,
    required this.textWidth,
    required this.context,
    this.textAlign = TextAlign.left,
    this.strTextColor = "000000",
    this.strTextFontFamily = "Poppins",
    this.fontSize = 14,
    this.fontHeight = 1.0,
    this.fontLetterSpacing = 0.0,
    this.fontWeight = FontWeight.normal,
    this.maxLine,
  });

  Widget getText() {
    return GlobalWidgets.setText(
      this.text,
      textAlign: this.textAlign,
      strTextColor: this.strTextColor,
      strTextFontFamily: this.strTextFontFamily,
      fontSize: this.fontSize,
      fontHeight: this.fontHeight,
      fontLetterSpacing: this.fontLetterSpacing,
      fontWeight: this.fontWeight,
      maxLine: this.maxLine,
    );
  }

  Size getSize() {
    return this._textSize(
        this.text,
        TextStyle(
            color: HexColor(this.strTextColor),
            fontFamily: this.strTextFontFamily,
            fontSize: this.fontSize * MediaQuery.textScaleFactorOf(context),
            fontWeight: this.fontWeight,
            height: this.fontHeight,
            letterSpacing: this.fontLetterSpacing),
        this.context,
        this.textWidth);
  }

  Size _textSize(String text, TextStyle style, BuildContext context, double correctionSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: correctionSize);

    return Size(textPainter.size.width, textPainter.size.height);
  }
}
