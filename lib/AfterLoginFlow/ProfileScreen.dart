import 'dart:convert';

import 'package:ISEEY/AfterLoginFlow/chat/ChatScreen.dart';
import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/ImageNetwork.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/ChatUserModel.dart';
import 'package:ISEEY/Models/TableListModel.dart';
import 'package:ISEEY/Models/UserModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatefulWidget {
  final UserDetail userDetail;
  final bool isFromChatScreen;

  ProfileScreen({
    Key? key,
    required this.userDetail,
    this.isFromChatScreen = false,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profileImage = '';
  String strDob = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    profileImage = widget.userDetail.image;
    _getLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetFriendListApi(scaffoldKey);
    });
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(
      widget.userDetail.dob.isEmpty ? "898108200000" : widget.userDetail.dob,
    ));
    strDob = convertStringFromDate(date: dob, dateWantInFormat: "dd-MM-yyyy");

    description = widget.userDetail.description;
  }

  List<ChatUserResult> chatUserListResult = [];
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
                          AssetsConstant.instance.leftArrowIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
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
                        L10n.current.menu_profile_title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: profileImage.isEmpty
                    ? CircleAvatar(
                        radius: 71.0,
                        backgroundColor: AppColors.mainBackgroundColorOrange,
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: AssetImage(
                            AssetsConstant.instance.manPlaceholder,
                          ),
                          backgroundColor: AppColors.mainBackgroundColorOrange,
                        ),
                      )
                    : CircleAvatar(
                        radius: 71.0,
                        backgroundColor: AppColors.mainBackgroundColorOrange,
                        child: ClipOval(
                          child: CircleAvatar(
                            radius: 70.0,
                            child: ImageNetwork(
                              url: profileImage,
                              fit: BoxFit.cover,
                              placeHolder: Center(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      AssetsConstant.instance.manPlaceholder,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: GlobalWidgets.setText(
                  widget.userDetail.firstName +
                      " " +
                      widget.userDetail.lastName,
                  strTextColor: AppColors.strMainTextColorWhite,
                  fontSize: 22,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
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
                                  Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    alignment: Alignment.center,
                                    child: Neumorphic(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Center(
                                        child: Image.asset(
                                          AssetsConstant.instance.userIcon,
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
                                        shadowDarkColor:
                                            AppColors.innerShadowColor,
                                        shadowLightColorEmboss:
                                            Colors.transparent,
                                        shadowDarkColorEmboss:
                                            AppColors.innerShadowColor,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: AppColors.listBoxBackgroundColor,
                                    thickness: 2,
                                    width: 0,
                                    endIndent: 10,
                                    indent: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: GlobalWidgets.setText(
                                              L10n.current.menu_friends_title,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              strTextColor: AppColors
                                                  .strMainTextColorWhite,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: GlobalWidgets.setText(
                                              widget.userDetail.friendsCount
                                                  .toString(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              strTextColor: AppColors
                                                  .strMainTextColorWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
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
                                  Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    alignment: Alignment.center,
                                    child: Neumorphic(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Center(
                                        child: Image.asset(
                                          AssetsConstant.instance.calendar,
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
                                        shadowDarkColor:
                                            AppColors.innerShadowColor,
                                        shadowLightColorEmboss:
                                            Colors.transparent,
                                        shadowDarkColorEmboss:
                                            AppColors.innerShadowColor,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: AppColors.listBoxBackgroundColor,
                                    thickness: 2,
                                    width: 0,
                                    endIndent: 10,
                                    indent: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: GlobalWidgets.setText(
                                              L10n.current
                                                  .profile_page_birth_date_title,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              strTextColor: AppColors
                                                  .strMainTextColorWhite,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: GlobalWidgets.setText(
                                                  strDob,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  strTextColor: AppColors
                                                      .strMainTextColorWhite,
                                                  maxLine: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (description.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 20),
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
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      alignment: Alignment.center,
                                      child: Neumorphic(
                                        padding:
                                            EdgeInsets.fromLTRB(6, 6, 6, 6),
                                        child: Center(
                                          child: Image.asset(
                                            AssetsConstant.instance.info,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          depth: -3,
                                          lightSource: LightSource.top,
                                          color:
                                              AppColors.listBoxBackgroundColor,
                                          border: NeumorphicBorder(
                                            color: AppColors.innerShadowColor,
                                            width: 1,
                                          ),
                                          shadowDarkColor:
                                              AppColors.innerShadowColor,
                                          shadowLightColorEmboss:
                                              Colors.transparent,
                                          shadowDarkColorEmboss:
                                              AppColors.innerShadowColor,
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: AppColors.listBoxBackgroundColor,
                                      thickness: 2,
                                      width: 0,
                                      endIndent: 10,
                                      indent: 10,
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                child: GlobalWidgets.setText(
                                                  description,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  strTextColor: AppColors
                                                      .strMainTextColorWhite,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  color: AppColors.mainBackgroundColorOrange,
                                  depth: -3,
                                  lightSource: LightSource.top,
                                  shadowDarkColor: AppColors.innerShadowColor,
                                  shadowLightColor: Colors.transparent,
                                  shadowLightColorEmboss: Colors.transparent,
                                  shadowDarkColorEmboss:
                                      AppColors.innerShadowColor,
                                  border: NeumorphicBorder(
                                    color: Color(0x33000000),
                                    width: 0.1,
                                  ),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(30)),
                                ),
                                onPressed: () {
                                  globalWidget.showPopUpWithMessage(
                                    isTitleEnable: false,
                                    context:
                                        scaffoldKey.currentContext ?? context,
                                    conditionButtonEnable: true,
                                    onPressOKButton: () {
                                      widget.userDetail.isBlocked
                                          ? callUnBlockUserApi(scaffoldKey)
                                          : callBlockUserApi(scaffoldKey);
                                    },
                                    titleMessage: L10n.current.app_name,
                                    message: widget.userDetail.isBlocked
                                        ? L10n.current
                                            .blocked_user_unblock_user_warning_message
                                        : L10n.current
                                            .chat_page_block_user_warning_message,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GlobalWidgets.setText(
                                    widget.userDetail.isBlocked
                                        ? L10n.current
                                            .profiel_page_unblock_user_action_title
                                        : L10n.current
                                            .profiel_page_block_user_action_title,
                                    textAlign: TextAlign.center,
                                    fontSize: 16,
                                    maxLine: 1,
                                    strTextColor:
                                        AppColors.strMainTextColorWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(width: 12),
                          Expanded(
                            child: Container(
                              height: 60,
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  color: AppColors.mainBackgroundColorOrange,
                                  depth: -3,
                                  lightSource: LightSource.top,
                                  shadowDarkColor: AppColors.innerShadowColor,
                                  shadowLightColor: Colors.transparent,
                                  shadowLightColorEmboss: Colors.transparent,
                                  shadowDarkColorEmboss:
                                      AppColors.innerShadowColor,
                                  border: NeumorphicBorder(
                                    color: Color(0x33000000),
                                    width: 0.1,
                                  ),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(30)),
                                ),
                                onPressed: () async {
                                  widget.isFromChatScreen
                                      ? Navigator.pop(context)
                                      : navigateToChatScreen();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GlobalWidgets.setText(
                                    L10n.current.profiel_page_message_title,
                                    textAlign: TextAlign.center,
                                    fontSize: 16,
                                    maxLine: 1,
                                    strTextColor:
                                        AppColors.strMainTextColorWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String chatId = "";

  callGetFriendListApi(
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'socket/getChats',
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

        ChatUserModel modelData = ChatUserModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            chatUserListResult = modelData.result;
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

  _getLocation() async {
    final defaultValue = 0.0;
    Position _currentPosition = Position(
      latitude: double.parse(widget.userDetail.lat),
      longitude: double.parse(widget.userDetail.lng),
      timestamp: DateTime.now(),
      altitudeAccuracy: defaultValue,
      headingAccuracy: defaultValue,
      speedAccuracy: defaultValue,
      altitude: defaultValue,
      accuracy: defaultValue,
      heading: defaultValue,
      speed: defaultValue,
    );
    debugPrint('location: ${_currentPosition.latitude}');
  }

  Future<bool> callUnBlockUserApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    var data = new Map<String, dynamic>();
    data['user_id'] = widget.userDetail.userId;

    var body = json.encode(data);
    HttpRequestModel req = new HttpRequestModel(
      url: 'users/unblock',
      method: RequestMethodType.POST,
      body: body,
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

        int success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success == 200) {
          showSuccessOrFail(
            message,
            success,
            context,
            isTitleEnable: false,
          );
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

  Future<bool> callBlockUserApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    var data = new Map<String, dynamic>();
    data['user_id'] = widget.userDetail.userId;

    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
      url: 'users/block',
      method: RequestMethodType.POST,
      body: body,
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

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        debugPrint('message $message');
        if (success == 200) {
          showSuccessOrFail(L10n.current.login_success_title, success, context,
              isTitleEnable: false);
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

  Future<bool> callCreateOrGetChatApi(
      GlobalKey<ScaffoldState> scaffoldKey, String userId) async {
    var data = new Map<String, dynamic>();
    data['user_id'] = userId;

    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
        url: 'socket/createOrGetChat',
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
          setState(() {
            chatId = jsonRes["result"];
          });
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

  navigateToChatScreen() async {
    Map<String, dynamic> data = await getMapData("userdata");
    UserResult userInfo = UserResult.fromJson(data);

    widget.userDetail.sId = widget.userDetail.userId;
    bool isResponseSuccess =
        await callCreateOrGetChatApi(scaffoldKey, widget.userDetail.userId);

    if (isResponseSuccess) {
      Navigator.push(
        mainTabsScaffoldKey.currentContext ?? context,
        SlideLeftRoute(
          routeName: "/chat",
          page: ChatScreen(
            fromUser: userInfo,
            toUser: widget.userDetail,
            chatId: chatId,
          ),
        ),
      );
    }
  }
}
