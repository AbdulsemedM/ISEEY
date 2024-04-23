import 'dart:convert';

import 'package:ISEEY/AfterLoginFlow/BlockedUserScreen.dart';
import 'package:ISEEY/AfterLoginFlow/FriendsListScreen.dart';
import 'package:ISEEY/AfterLoginFlow/NewsLetterScreen.dart';
import 'package:ISEEY/AuthFlow/EditProfileScreen.dart';
import 'package:ISEEY/AuthFlow/LoginScreen.dart';
import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/UserModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/Services/notification_utils.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DrawerScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List<String> items = [
    L10n.current.menu_home_title,
    L10n.current.menu_friends_title,
    L10n.current.menu_profile_title,
    L10n.current.menu_newsletter_title,
    L10n.current.menu_blocked_users_title,
    L10n.current.menu_logout_title,
  ];

  @override
  void initState() {
    super.initState();
    if (currentSelectedTab == 1) {
      selectedMenuItemIndex = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserDetail();
      callGetCountApi(widget.scaffoldKey);
    });
  }

  UserResult? userInfo;

  getUserDetail() async {
    Map<String, dynamic> data = await getMapData("userdata");

    setState(() {
      userInfo = UserResult.fromJson(data);

      _getCurrentLocation();
    });
  }

  late Position _currentPosition;

  _getCurrentLocation() async {
    _currentPosition = await determinePosition();
    _getLocation();
  }

  String address = '';

  _getLocation() async {
    debugPrint('location: ${_currentPosition.latitude}');
    List<Placemark>? placeMarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

    if (placeMarks.isNotEmpty) {
      try {
        var subLocality = placeMarks[0].subLocality ?? '';
        var locality = placeMarks[0].locality ?? '';
        var administrativeArea = placeMarks[0].administrativeArea ?? '';
        if (subLocality.isNotEmpty && locality.isNotEmpty && administrativeArea.isNotEmpty) {
          address = "$subLocality, $locality, $administrativeArea";
        } else if (locality.isNotEmpty && administrativeArea.isNotEmpty) {
          address = "$locality, $administrativeArea";
        } else {
          address = "$administrativeArea";
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    setState(() {});
  }

  int? locationCount = 0;
  int? friendsCount = 0;

  callGetCountApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/getCounts', method: RequestMethodType.GET, body: '', params: '', headerType: "json", authMethod: true);
    var response;
    try {
      response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        int success = jsonRes["success"];

        if (success == 200) {
          setState(() {
            Map<String, dynamic> result = jsonRes["result"];
            locationCount = result['locations'];
            friendsCount = result['friends'];
          });
        } else {
          showSuccessOrFail(L10n.current.blocked_user_sorry_title, success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.screensBackgroundsColor,
              AppColors.screensBackgroundsColor,
              AppColors.fieldShadow,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0,
              0.8,
              1,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                        page: EditProfileScreen(),
                        routeName: '/editProfile',
                      )).then((value) {
                    if (mainTabsScaffoldKey.currentState?.isDrawerOpen ?? false) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: userInfo != null && (userInfo?.image == null)
                      ? CircleAvatar(
                          radius: 71.0,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundImage: AssetImage(AssetsConstant.instance.manPlaceholder),
                            backgroundColor: AppColors.mainBackgroundColorOrange,
                          ),
                        )
                      : userInfo?.image != null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: userInfo?.image ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: GlobalWidgets.setText(
                  userInfo == null ? '' : "${userInfo?.firstName} ${userInfo?.lastName}",
                  strTextColor: AppColors.strMainTextColorWhite,
                  fontSize: 22,
                ),
              ),
              if (address.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 3),
                          child: GlobalWidgets.setText(
                            address,
                            strTextColor: AppColors.strMainTextColorWhite,
                            fontSize: 18,
                            maxLine: 2,
                            fontHeight: 1.3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Neumorphic(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: 10),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10),
                                ),
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
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  AssetsConstant.instance.location,
                                  fit: BoxFit.contain,
                                  scale: 1,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: GlobalWidgets.setText(
                                    L10n.current.menu_locations_count_title,
                                    strTextColor: AppColors.strMainTextColorWhite,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: GlobalWidgets.setText(
                                    locationCount.toString(),
                                    strTextColor: AppColors.strMainTextColorWhite,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.listBoxBackgroundColor,
                            AppColors.mainTextColorWhite,
                            AppColors.listBoxBackgroundColor,
                          ],
                        ),
                      ),
                      width: 1,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Neumorphic(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: 10),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(10),
                                ),
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
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  AssetsConstant.instance.userWhiteIcon,
                                  fit: BoxFit.contain,
                                  scale: 1,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: GlobalWidgets.setText(
                                    L10n.current.menu_friends_count_title,
                                    strTextColor: AppColors.strMainTextColorWhite,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: GlobalWidgets.setText(
                                    friendsCount.toString(),
                                    strTextColor: AppColors.strMainTextColorWhite,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  itemCount: items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => setDrawerList(index),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setDrawerList(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItemIndex = index;

          switch (selectedMenuItemIndex) {
            case 0:
              Navigator.pop(context);

              break;
            case 1:
              Navigator.pop(context);
              Navigator.push(
                context,
                SlideLeftRoute(
                  page: FriendsListScreen(),
                  routeName: "/friendsList",
                ),
              );
              break;
            case 2:
              Navigator.pop(context);
              Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: EditProfileScreen(),
                    routeName: '/editProfile',
                  )).then((value) {
                if (mainTabsScaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.pop(context);
                }
              });
              break;
            case 3:
              Navigator.pop(context);
              Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: NewsLetterScreen(),
                    routeName: '/newsletter',
                  )).then((value) {
                if (mainTabsScaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.pop(context);
                }
              });
              break;
            case 4:
              Navigator.pop(context);
              Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: BlockedUserScreen(),
                    routeName: '/blockeduser',
                  )).then((value) {
                if (mainTabsScaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.pop(context);
                }
              });
              break;
            case 5:
              Navigator.pop(context);
              globalWidget.showPopUpWithMessage(
                context: mainTabsScaffoldKey.currentContext ?? context,
                conditionButtonEnable: true,
                titleMessage: "ISEEY",
                message: L10n.current.logout_warning_message,
                onPressOKButton: () {
                  _logoutNavigateToLogin(widget.scaffoldKey);
                },
              );
              break;

            default:
          }
        });
      },
      child: Column(
        children: [
          index == 0
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.listBoxBackgroundColor,
                        AppColors.mainTextColorWhite,
                        AppColors.listBoxBackgroundColor,
                      ],
                    ),
                  ),
                  height: 1,
                )
              : SizedBox(),
          selectedMenuItemIndex == index
              ? Container(
                  height: 50,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(1),
                      ),
                      depth: -5,
                      lightSource: LightSource.top,
                      color: HexColor("1d2128"),
                      border: NeumorphicBorder(
                        color: AppColors.innerShadowColor,
                        width: 0,
                      ),
                      shadowDarkColor: Colors.transparent,
                      shadowLightColorEmboss: Colors.transparent,
                      shadowDarkColorEmboss: Colors.transparent,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VerticalDivider(
                            thickness: 1.5,
                            width: 0,
                            color: AppColors.mainBackgroundColorOrange,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                              alignment: Alignment.center,
                              child: GlobalWidgets.setText(items[index],
                                  fontSize: 18, fontWeight: FontWeight.w500, strTextColor: AppColors.strMainTextColorWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  margin: EdgeInsets.only(bottom: 0),
                  alignment: Alignment.center,
                  child: GlobalWidgets.setText(items[index],
                      fontSize: 18, fontWeight: FontWeight.w500, strTextColor: AppColors.strMainTextColorWhite),
                ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.listBoxBackgroundColor,
                  AppColors.mainTextColorWhite,
                  AppColors.listBoxBackgroundColor,
                ],
              ),
            ),
            height: 1,
          ),
        ],
      ),
    );
  }

  _logoutNavigateToLogin(GlobalKey<ScaffoldState> scaffoldKey) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/logout', method: RequestMethodType.GET, body: '', params: '', headerType: "json", authMethod: true);
    var response;
    try {
      var x = GlobalWidgets();
      x.showLoading(scaffoldKey.currentContext ?? context);

      response = await HttpService().init(req, scaffoldKey);

      Future.delayed(const Duration(milliseconds: 800), () {
        x.hideLoading();
        if (mounted) setState(() {});
      });
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        int success = jsonRes["success"];

        if (success == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          prefs.setBool("isFromLogin", false);
          NotificationUtils().clearAllNotifications();

          Navigator.pushReplacement(
            mainTabsScaffoldKey.currentContext ?? context,
            SlideRightRoute(
              page: LoginScreen(),
              routeName: "/login",
            ),
          );
          if (mounted) {
            setState(() {});
          }
        } else {
          showSuccessOrFail(L10n.current.blocked_user_sorry_title, success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setBool("isFromLogin", false);
    NotificationUtils().clearAllNotifications();

    Navigator.pushReplacement(
      mainTabsScaffoldKey.currentContext ?? context,
      SlideRightRoute(
        page: LoginScreen(),
        routeName: "/login",
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }
}
