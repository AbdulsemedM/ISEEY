import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          color: AppColors.mainBackgroundColorOrange,
          depth: -3,
          lightSource: LightSource.top,
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColor: Colors.transparent,
          shadowLightColorEmboss: Colors.transparent,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
          border: NeumorphicBorder(
            color: Color(0x33000000),
            width: 0.1,
          ),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: GlobalWidgets.setText(
            text,
            textAlign: TextAlign.center,
            fontSize: 16,
            maxLine: 1,
            strTextColor: AppColors.strMainTextColorWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
