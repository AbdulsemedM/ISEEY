import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/AfterLoginFlow.dart';
import 'package:iseey/CustomTabbarController/CustomBottomNavigationBar.dart';
import 'package:iseey/Drawer/DrawerScreen.dart';
import 'package:iseey/GlobalFiles/GlobalFiles.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

import 'CustomNavigator.dart';

class CustomTabBarController extends StatefulWidget {
  late final int? fromChat;

  CustomTabBarController({
    Key? key,
    this.fromChat = 1,
  }) : super(key: key);

  @override
  CustomTabBarControllerState createState() => CustomTabBarControllerState();
}

class CustomTabBarControllerState extends State<CustomTabBarController> {
  int? selectedIndex = inActivateBottomBar ? -1 : currentSelectedTab;
  List<String> bottomTabs = ["/tab1", "/tab2", "/tab3"];

  @override
  void initState() {
    if (widget.fromChat == 2) {
      currentSelectedTab = 2;
      selectedMenuItemIndex = 0;
    } else {
      currentSelectedTab = 1;
      selectedMenuItemIndex = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: mainTabsScaffoldKey,
        backgroundColor: AppColors.screensBackgroundsColor,
        body: Stack(
          children: <Widget>[
            offStateNavigator(routePath: "/tab1", widget: RestaurantScreen()),
            offStateNavigator(routePath: "/tab2", widget: RestaurantList()),
            offStateNavigator(routePath: "/tab3", widget: ChatPartnerScreen()),
          ],
        ),
        drawer: setDrawer(),
        bottomNavigationBar: setBottomBar(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (BuildContext _) {
            return AlertDialog(
              title: Text(L10n.current.are_you_sure_message),
              content: Text(L10n.current.app_logout_warning_message),
              actions: <Widget>[
                MaterialButton(
                  child: Text(L10n.current.decline_button_title),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                MaterialButton(
                  child: Text(L10n.current.accept_button_title),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  setDrawer() {
    return DrawerScreen(
      scaffoldKey: mainTabsScaffoldKey,
    );
  }

  Widget offStateNavigator({
    required Widget widget,
    required String routePath,
    GlobalKey<NavigatorState>? navKey,
  }) {
    String currentRoutePath = bottomTabs[currentSelectedTab];

    return Offstage(
      offstage: currentRoutePath != routePath,
      child: CustomNavigator(
        navKey: navKey ?? CustomNavigatorKeys.createOrGetKey(routePath),
        widget: widget,
        route: routePath,
      ),
    );
  }

  bool isConditionTrue() {
    if (selectedRestaurantId == null && currentSelectedTab == 0) {
      return false;
    } else {
      return true;
    }
  }

  setBottomBar() {
    return Container(
        color: AppColors.screensBackgroundsColor,
        child: Container(
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
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => onBottomTabClick(0),
                        child: ItemWidget(
                          item: addTabBardItems("", AssetsConstant.tab1Icon, 0),
                          iconSize: 30,
                          isSelected: 0 == selectedIndex,
                          backgroundColor: AppColors.screensBackgroundsColor,
                          itemCornerRadius: 50,
                          animationDuration: Duration(milliseconds: 270),
                          curve: Curves.linear,
                        ),
                      ),
                      InkWell(
                        onTap: () => onBottomTabClick(1),
                        child: ItemWidget(
                          item: addTabBardItems("", AssetsConstant.tab2Icon, 1),
                          iconSize: 30,
                          isSelected: 1 == selectedIndex,
                          backgroundColor: AppColors.screensBackgroundsColor,
                          itemCornerRadius: 50,
                          animationDuration: Duration(milliseconds: 270),
                          curve: Curves.linear,
                        ),
                      ),
                      InkWell(
                        onTap: () => onBottomTabClick(2),
                        child: ItemWidget(
                          item: addTabBardItems("", AssetsConstant.tab3Icon, 2),
                          iconSize: 30,
                          isSelected: 2 == selectedIndex,
                          backgroundColor: AppColors.screensBackgroundsColor,
                          itemCornerRadius: 50,
                          animationDuration: Duration(milliseconds: 270),
                          curve: Curves.linear,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  openChat() {
    Future.delayed(const Duration(milliseconds: 500), () {
      selectedMenuItemIndex = 0;
      onBottomTabClick(2);
    });
    // CustomBottomNavyBar(items: [], onItemSelected: (int value) {  },).onClick(2);
  }

  onBottomTabClick(index) {
    currentSelectedTab = index;
    selectedIndex = index;

    setState(() {
      if (index == 2) {
        Provider.of<StateManagement>(mainTabsScaffoldKey.currentContext ?? context, listen: false).reloadBuild();
      }
      if (!isConditionTrue()) {
        currentSelectedTab = 1;
        showSuccessOrFail(
          L10n.current.no_restaurant_selected_error_message,
          false,
          context,
          isCustom: true,
          onCustomOkPress: () => setState(() => currentSelectedTab = 1),
        );
        return;
      } else {
        if (index == 0) {
          Provider.of<StateManagement>(mainTabsScaffoldKey.currentContext ?? context, listen: false)
              .reloadRestaurantBuild();
        }
      }
      if (currentSelectedTab == 1) {
        selectedMenuItemIndex = 0;
      } else {
        selectedMenuItemIndex = -1;
      }
    });
  }
}
