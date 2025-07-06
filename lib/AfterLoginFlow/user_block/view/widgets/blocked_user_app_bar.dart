import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class BlockedUserAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
            onPressed: () {
              Navigator.pop(context);
            },
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
        ),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 45),
            height: 45,
            width: double.infinity,
            child: GlobalWidgets.setText(
              L10n.current.blocked_user_title,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              strTextColor: AppColors.strMainTextColorWhite,
            ),
          ),
        ),
      ],
    );
  }
}