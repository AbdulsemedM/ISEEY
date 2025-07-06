import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';



class ProfileInfoItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? value;
  final bool isDescription;
  
  const ProfileInfoItem({
    Key? key,
    required this.icon,
    required this.title,
    this.value,
    this.isDescription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: isDescription ? 20 : 40),
      width: double.infinity,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: -3,
          lightSource: LightSource.top,
          color: AppColors.screensBackgroundsColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 1,
          ),
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColorEmboss: Colors.transparent,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
        ),
        child: Container(
          child: IntrinsicHeight(
            child: Row(
              children: [
                _buildIcon(),
                VerticalDivider(
                  color: AppColors.listBoxBackgroundColor,
                  thickness: 2,
                  width: 0,
                  endIndent: 10,
                  indent: 10,
                ),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      alignment: Alignment.center,
      child: Neumorphic(
        padding: isDescription ? EdgeInsets.fromLTRB(6, 6, 6, 6) : EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Image.asset(
            icon,
            fit: BoxFit.contain,
          ),
        ),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: -3,
          lightSource: LightSource.top,
          color: AppColors.listBoxBackgroundColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 1,
          ),
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColorEmboss: Colors.transparent,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GlobalWidgets.setText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
            ),
            if (value != null && !isDescription)
              Container(
                padding: EdgeInsets.only(left: 15),
                child: GlobalWidgets.setText(
                  value!,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  strTextColor: AppColors.strMainTextColorWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }
}