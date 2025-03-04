import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/BlockedUserListModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class BlockedUserScreen extends StatefulWidget {
  @override
  _BlockedUserScreenState createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetBlockedUserListApi(scaffoldKey);
    });
  }

  List<BlockedUserResult> blockedUserList = [];

  callGetBlockedUserListApi(
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/blockedList',
        method: RequestMethodType.GET,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        BlockedUserListModel modelData = BlockedUserListModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            blockedUserList = modelData.result;
          });
        } else {
          showSuccessOrFail(modelData.message, false, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

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
                        L10n.current.blocked_user_title,
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
                    itemCount: blockedUserList.length == 0 ? 1 : blockedUserList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return blockedUserList.length == 0
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
                              )),
                            )
                          : setListItem(index);
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

  Future<bool> callUnBlockUserApi(String userId) async {
    var data = new Map<String, dynamic>();
    data['user_id'] = userId;

    var body = json.encode(data);
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/unblock',
        method: RequestMethodType.POST,
        body: body,
        params: '',
        headerType: "json",
        authMethod: true);
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
          Provider.of<StateManagement>(context, listen: false).reloadBuild();
          callGetBlockedUserListApi(scaffoldKey);
          showSuccessOrFail(
            message,
            true,
            context,
            isCustom: true,
            isTitleEnable: false,
            onCustomOkPress: () {},
          );
          return true;
        } else {
          showSuccessOrFail(message, false, context);
          return false;
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
    return false;
  }

  setListItem(int index) {
    BlockedUserResult blockedUser = blockedUserList[index];
    String dobStr = blockedUser.userDetail?.dob ?? '';
    String dobTest = dobStr.isEmpty ? '898108200000' : dobStr;
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(dobTest));
    int age = calculateAge(dob);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        globalWidget.showPopUpWithMessage(
          context: mainTabsScaffoldKey.currentContext ?? context,
          conditionButtonEnable: true,
          isTitleEnable: false,
          onPressOKButton: () {
            callUnBlockUserApi(blockedUser.userDetail?.sId ?? '');
          },
          message: L10n.current.blocked_user_unblock_user_warning_message + '?',
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Neumorphic(
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
                        imageUrl: blockedUser.userDetail?.image ?? '',
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
                            "${blockedUser.userDetail?.firstName} ${blockedUser.userDetail?.lastName}",
                            fontSize: 16,
                            strTextColor: AppColors.strMainTextColorWhite,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
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
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20, right: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        child: Image.asset(
                          AssetsConstant.pwdIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: GlobalWidgets.setText(
                          L10n.current.blocked_user_unblock_title,
                          strTextColor: AppColors.strFieldShadow,
                          fontSize: 12,
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
