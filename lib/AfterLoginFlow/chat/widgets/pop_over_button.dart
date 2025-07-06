import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';

class PopOverButton extends StatelessWidget {
  final Function onTap;

  const PopOverButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: GestureDetector(
        child: Neumorphic(
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
          child: Center(
            child: Icon(
              Icons.more_vert,
              color: AppColors.mainTextColorWhite,
              size: 35,
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
