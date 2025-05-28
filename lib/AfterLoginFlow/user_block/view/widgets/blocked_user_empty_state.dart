import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class BlockedUserEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: screenSize.width - 40,
          height: screenSize.width - 40,
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
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                        child: Image.asset(
                          AssetsConstant.errorIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: GlobalWidgets.setText(
                          L10n.current.blocked_user_sorry_title,
                          strTextColor: AppColors.strMainTextColorWhite,
                          textAlign: TextAlign.center,
                          fontSize: 26,
                        ),
                      ),
                      Container(
                        child: GlobalWidgets.setText(
                          L10n.current.blocked_user_no_data_title,
                          strTextColor: AppColors.strMainTextColorWhite,
                          textAlign: TextAlign.center,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}