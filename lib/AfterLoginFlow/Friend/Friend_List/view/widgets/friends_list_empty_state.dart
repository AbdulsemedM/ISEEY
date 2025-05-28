import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';

class FriendsListEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.width - 40,
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
                          'No Friends Yet',
                          strTextColor: AppColors.strMainTextColorWhite,
                          textAlign: TextAlign.center,
                          fontSize: 26,
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