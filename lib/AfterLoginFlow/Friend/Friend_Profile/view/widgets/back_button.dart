import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';

class Backbutton extends StatelessWidget {
  final BuildContext context;

  const Backbutton({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      child: NeumorphicButton(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Image.asset(
            AssetsConstant.leftArrowIcon,
            fit: BoxFit.contain,
          ),
        ),
        onPressed: () => Navigator.pop(context),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: -2,
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
    );
  }
}
