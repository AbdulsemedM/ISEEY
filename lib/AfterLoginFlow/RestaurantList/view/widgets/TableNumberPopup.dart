// lib/widgets/TableNumberPopup.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TableNumberPopup extends StatefulWidget {
  final bool showNewsLetter;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final TextEditingController tableNumberController;
  final bool initialAgreeValue;

  const TableNumberPopup({
    required this.showNewsLetter,
    required this.onConfirm,
    required this.onCancel,
    required this.tableNumberController,
    required this.initialAgreeValue,
  });

  @override
  _TableNumberPopupState createState() => _TableNumberPopupState();
}

class _TableNumberPopupState extends State<TableNumberPopup> {
  late bool isAgree;

  @override
  void initState() {
    super.initState();
    isAgree = widget.initialAgreeValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.screensBackgroundsColor,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: widget.showNewsLetter ? 200 : 250,
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                depth: -3,
                color: AppColors.tabBarBoxBackgroundColor,
                border: NeumorphicBorder(
                  color: AppColors.innerShadowColor,
                  width: 0.1,
                ),
                intensity: 0.5,
                shadowDarkColor: AppColors.innerShadowColor,
                shadowLightColorEmboss: AppColors.innerShadowColor,
                shadowDarkColorEmboss: AppColors.innerShadowColor,
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20, top: 30),
                          child: GlobalWidgets.setText(
                            L10n.current.table_pop_up_subtitile,
                            fontSize: 18,
                            strTextColor: AppColors.strMainTextColorWhite,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                          height: 45,
                          width: double.infinity,
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
                              intensity: 0.5,
                              shadowDarkColor: AppColors.innerShadowColor,
                              shadowLightColorEmboss: Colors.transparent,
                              shadowDarkColorEmboss: AppColors.innerShadowColor,
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
                              child: TextField(
                                keyboardAppearance: Brightness.dark,
                                controller: widget.tableNumberController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        if (!widget.showNewsLetter)
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isAgree = !isAgree;
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      isAgree 
                                        ? AssetsConstant.selectedCheckbox
                                        : AssetsConstant.unselectedCheckbox,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      isAgree = !isAgree;
                                    });
                                  },
                                  child: GlobalWidgets.setText(
                                    L10n.current.table_pop_up_newsletter_checkbox_text,
                                    textAlign: TextAlign.left,
                                    strTextColor: AppColors.strMainTextColorWhite,
                                    fontSize: 15,
                                    maxLine: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                child: Container(
                                  height: 45,
                                  width: 120,
                                  child: GlobalWidgets.setButton(
                                    onPressButton: widget.onConfirm,
                                    textWidget: Container(
                                      padding: EdgeInsets.only(top: 3),
                                      alignment: Alignment.center,
                                      child: GlobalWidgets.setText(
                                        L10n.current.done_title,
                                        textAlign: TextAlign.center,
                                        fontSize: 16,
                                        strTextColor: AppColors.strMainTextColorWhite,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  height: 45,
                                  width: 120,
                                  child: GlobalWidgets.setButton(
                                    strButtonColor: "c8c8c8",
                                    onPressButton: widget.onCancel,
                                    textWidget: Container(
                                      padding: EdgeInsets.only(top: 3),
                                      alignment: Alignment.center,
                                      child: GlobalWidgets.setText(
                                        L10n.current.cancel_button_title,
                                        textAlign: TextAlign.center,
                                        fontSize: 16,
                                        strTextColor: "1c1c1c",
                                        fontWeight: FontWeight.w400,
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 45,
                      height: 45,
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: AppColors.mainTextColorWhite,
                            size: 30,
                          ),
                        ),
                        onPressed: widget.onCancel,
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: -3,
                          color: AppColors.listBoxBackgroundColor,
                          border: NeumorphicBorder(
                            color: AppColors.innerShadowColor,
                            width: 0.1,
                          ),
                          intensity: 0.6,
                          shadowDarkColor: AppColors.innerShadowColor,
                          shadowLightColorEmboss: AppColors.innerShadowColor,
                          shadowDarkColorEmboss: AppColors.innerShadowColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}