import 'dart:convert';

import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/FriendListModel.dart';
import 'package:ISEEY/Models/TableListModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ProfileScreen.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetFriendListApi(scaffoldKey);
    });
  }

  List<FriendListResult> friendListResult = [];

  callGetFriendListApi(
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'friends/friendsList',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        FriendListModel modelData = FriendListModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            friendListResult.clear();
            friendListResult = modelData.result;
          });
        } else {
          showSuccessOrFail(modelData.message, modelData.success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  Future<bool> callUnFriendUser(GlobalKey<ScaffoldState> scaffoldKey, String strId) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'friends/unfriend/$strId', method: RequestMethodType.DELETE, body: '', params: '', headerType: "json", authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        if (success == 200) {
          callGetFriendListApi(scaffoldKey);
          return true;
        } else {
          showSuccessOrFail(message, success, context);
          return false;
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
    return false;
  }

  Future<bool> callUpdateUser(GlobalKey<ScaffoldState> scaffoldKey, String? strId) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/getUserDetail/$strId', method: RequestMethodType.GET, body: '', params: '', headerType: "json", authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        UserDetail modelData = UserDetail.fromJson(jsonRes["result"]);
        if (success == 200) {
          navigateToProfile(modelData);
          return true;
        } else {
          showSuccessOrFail(message, success, context);
          return false;
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
    return false;
  }

  navigateToProfile(UserDetail user) {
    Navigator.push(
      context,
      SlideLeftRoute(
        routeName: "/profileScreen",
        page: ProfileScreen(
          userDetail: user,
        ),
      ),
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
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
                        L10n.current.friends_list_title,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    itemCount: friendListResult.length == 0 ? 1 : friendListResult.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          final listResult = friendListResult;
                          FriendListResult friend = listResult[index];
                          callUpdateUser(scaffoldKey, friend.friendDetail?.sId);
                        },
                        child: Neumorphic(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(5),
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
                          child: Slidable(
                            key: ValueKey(index),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              extentRatio: 0.24,
                              children: [
                                CustomSlidableAction(
                                  backgroundColor: AppColors.listBoxBackgroundColor,
                                  onPressed: (BuildContext context) {},
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: NeumorphicButton(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Center(
                                        child: Image.asset(
                                          AssetsConstant.deleteIcon,
                                          fit: BoxFit.contain,
                                          scale: 1.2,
                                        ),
                                      ),
                                      onPressed: () {
                                        globalWidget.showPopUpWithMessage(
                                            context: mainTabsScaffoldKey.currentContext ?? context,
                                            conditionButtonEnable: true,
                                            titleMessage: L10n.current.app_name,
                                            onPressOKButton: () {
                                              final listResult = friendListResult;
                                              FriendListResult friend = listResult[index];
                                              callUnFriendUser(scaffoldKey, friend.friendId);
                                            },
                                            message: L10n.current.friends_list_remove_friend_warning_message);
                                      },
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape: NeumorphicBoxShape.circle(),
                                        depth: -5,
                                        lightSource: LightSource.top,
                                        color: AppColors.listBoxBackgroundColor,
                                        border: NeumorphicBorder(
                                          color: AppColors.innerShadowColor,
                                          width: 2,
                                        ),
                                        shadowDarkColor: AppColors.innerShadowColor,
                                        shadowLightColorEmboss: Colors.transparent,
                                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: friendListResult.length == 0
                                ? Container(
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
                                  )
                                : setListItem(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setListItem(int index) {
    FriendListResult? friend = friendListResult[index];
    String dobStr = friend.friendDetail?.dob ?? '';
    String dobTest = dobStr.isEmpty ? '898108200000' : dobStr;
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(dobTest));
    int age = calculateAge(dob);

    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: friend.friendDetail?.image ?? '',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: HexColor("F3F3F3"),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 80,
                        width: 80,
                        child: GFAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          maxRadius: 20,
                          backgroundImage: AssetImage(
                            AssetsConstant.manPlaceholder,
                          ),
                          shape: GFAvatarShape.square,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                      child: GlobalWidgets.setText(
                        "${friend.friendDetail?.firstName} ${friend.friendDetail?.lastName}",
                        fontSize: 16,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: GlobalWidgets.setText(
                        friend.friendDetail?.description ?? '',
                        fontSize: 12,
                        maxLine: 2,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 0),
                          child: GlobalWidgets.setText(
                            friend.friendDetail?.countyDetails?.name ?? '',
                            fontSize: 12,
                            strTextColor: AppColors.strFieldShadow,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            AssetsConstant.countryTemp,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: GlobalWidgets.setText(
                            L10n.current.table_user_list_user_age(age),
                            strTextColor: AppColors.strFieldShadow,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (friend.friendDetail?.facebook != null)
                  Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: NeumorphicButton(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Image.asset(
                          AssetsConstant.facebook,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () => launch(
                        friend.friendDetail?.facebook ?? '',
                        universalLinksOnly: true,
                      ),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: -5,
                        lightSource: LightSource.top,
                        color: AppColors.listBoxBackgroundColor,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 0.3,
                        ),
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: AppColors.innerShadowColor,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                    ),
                  ),
                if (friend.friendDetail?.facebook != null && friend.friendDetail?.instagram != null)
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
                    width: 40,
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                if (friend.friendDetail?.instagram != null)
                  Container(
                    width: 35,
                    height: 35,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: NeumorphicButton(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Image.asset(
                          AssetsConstant.instagram,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () => launch(
                        friend.friendDetail?.instagram ?? '',
                        universalLinksOnly: true,
                      ),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: -5,
                        lightSource: LightSource.top,
                        color: AppColors.listBoxBackgroundColor,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 0.3,
                        ),
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: AppColors.innerShadowColor,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
