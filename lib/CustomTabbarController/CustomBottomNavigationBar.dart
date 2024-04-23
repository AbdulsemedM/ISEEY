library bottom_navy_bar;

import 'package:ISEEY/Services/assets_constant.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';

class CustomBottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool? showElevation;
  final Duration animationDuration;
  final List<CustomBottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment? mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final Curve curve;


  CustomBottomNavyBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.containerHeight = 56,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) {
    assert(items.length >= 2 && items.length <= 5);
  }




  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null) ? Theme.of(context).bottomAppBarTheme.color : backgroundColor;

    return Container(
      child: Container(
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: items.map((item) {
            var index = items.indexOf(item);
            return InkWell(
              onTap: () => onClick(index),
              child: ItemWidget(
                item: item,
                iconSize: iconSize,
                isSelected: index == selectedIndex,
                backgroundColor: bgColor,
                itemCornerRadius: itemCornerRadius,
                animationDuration: animationDuration,
                curve: curve,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  onClick(int index) {
    onItemSelected(index);
  }
}

class ItemWidget extends StatelessWidget {
  final double? iconSize;
  final bool isSelected;
  final CustomBottomNavyBarItem item;
  final Color? backgroundColor;
  final double? itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 270),
    required this.itemCornerRadius,
    required this.iconSize,
    this.curve = Curves.linear,
  })  : assert(backgroundColor != null),
        assert(itemCornerRadius != null),
        assert(iconSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 80,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          isSelected
              ? Neumorphic(
                  padding: EdgeInsets.fromLTRB(25, 22, 25, 22),
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: -3,
                    lightSource: LightSource(-0.3, -1),
                    color: AppColors.tabBarBoxBackgroundColor,
                    border: NeumorphicBorder(
                      color: AppColors.innerShadowColor,
                      width: 0.1,
                    ),
                    intensity: 0.7,
                    shadowDarkColor: AppColors.innerShadowColor,
                    shadowLightColorEmboss: Colors.transparent,
                    shadowDarkColorEmboss: AppColors.innerShadowColor,
                  ),
                  child: item.icon,
                )
              : item.icon,
        ],
      ),
    );
  }
}

class CustomBottomNavyBarItem {
  final Widget icon;
  final Widget? title;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  CustomBottomNavyBarItem({
    required this.icon,
    @required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
    this.fontWeight,
  }) {
    assert(title != null);
  }
}

Widget createBottomTabBar({required Function(int) onTabPressed}) {
  return Container(
    color: AppColors.screensBackgroundsColor,
    margin: EdgeInsets.only(
      bottom: 10,
      top: 0,
    ),
    height: 90,
    child: Stack(
      children: [
        Neumorphic(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(90 / 2),
              ),
              depth: -2,
              color: AppColors.tabBarBoxBackgroundColor,
              border: NeumorphicBorder(
                color: AppColors.innerShadowColor,
                width: 0.2,
              ),
              shadowDarkColor: AppColors.innerShadowColor,
              intensity: 0.7,
              shadowLightColorEmboss: Colors.transparent,
              shadowDarkColorEmboss: AppColors.innerShadowColor,
            ),
            child: Container()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: CustomBottomNavyBar(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            backgroundColor: AppColors.screensBackgroundsColor,
            selectedIndex: inActivateBottomBar ? -1 : currentSelectedTab,
            showElevation: false,
            iconSize: 30,
            items: [
              addTabBardItems("", AssetsConstant.instance.tab1Icon, 0),
              addTabBardItems("", AssetsConstant.instance.tab2Icon, 1),
              addTabBardItems("", AssetsConstant.instance.tab3Icon, 2),
            ],
            onItemSelected: (index) => onTabPressed(index),
          ),
        ),
      ],
    ),
  );
}

addTabBardItems(String title, String imagePath, int selectedIndex) {
  return CustomBottomNavyBarItem(
    icon: Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image.asset(
        imagePath,
        width: 30.0,
        color: currentSelectedTab == selectedIndex ? AppColors.mainBackgroundColorOrange : AppColors.mainTextColorWhite,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    ),
    title: SizedBox(),
    activeColor: AppColors.mainBackgroundColorOrange,
    inactiveColor: AppColors.mainTextColorWhite,
    fontWeight: FontWeight.w600,
  );
}
