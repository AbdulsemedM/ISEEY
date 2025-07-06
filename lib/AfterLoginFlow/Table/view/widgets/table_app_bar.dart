import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TableAppBar extends StatelessWidget {
  final Future<bool> Function() onBackPressed;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const TableAppBar({
    Key? key,
    required this.onBackPressed,
    required this.searchController,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: NeumorphicButton(
            padding: EdgeInsets.zero,
            child: Center(
              child: Image.asset(
                AssetsConstant.leftArrowIcon,
                fit: BoxFit.contain,
              ),
            ),
            onPressed: onBackPressed,
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              depth: 1,
              lightSource: LightSource.top,
              color: AppColors.mainTextColorBlack.withOpacity(0.7),
              border: NeumorphicBorder(
                color: AppColors.innerShadowColor,
                width: 2,
              ),
              shadowDarkColor: AppColors.mainBackgroundColorOrange,
              shadowLightColorEmboss: Colors.transparent,
              shadowDarkColorEmboss: AppColors.innerShadowColor,
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 15),
            height: 45,
            child: Neumorphic(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
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
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  style: TextStyle(
                    color: AppColors.mainTextColorWhite,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    onSearchChanged(searchController.text);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Container(
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: AppColors.mainTextColorWhite,
                        ),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.fieldShadow,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    hintText: L10n.current.restaurant_list_seach_bar_hint_text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}