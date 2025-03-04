import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Models/UserModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/ChatScreen.dart';

class ChatPartnerScreen extends StatefulWidget {
  @override
  _ChatPartnerScreenState createState() => _ChatPartnerScreenState();
}

class _ChatPartnerScreenState extends State<ChatPartnerScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool? loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetFriendListApi(scaffoldKey, showLoader: true);
    });

    firebaseNotificationListen();
  }

  void firebaseNotificationListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }
      var jsonData = jsonDecode(jsonEncode(message.data));
      try {
        if (jsonData["notification_type"] == "chat_message") {
          callGetFriendListApi(scaffoldKey, showLoader: false);
        }
      } catch (_) {}
    });
  }

  List<ChatUserResult> chatUserListResult = [];

  callGetFriendListApi(GlobalKey<ScaffoldState> scaffoldKey, {required bool showLoader}) async {
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
      if (showLoader) {
        x.showLoading(scaffoldKey.currentContext ?? context);
      }
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        ChatUserModel modelData = ChatUserModel.fromJson(jsonRes);

        if (modelData.success) {
          setState(() {
            chatUserListResult = modelData.result;
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

  callRebuild() {
    Provider.of<StateManagement>(context).isReload = false;
    Future.delayed(Duration(milliseconds: 1), () {
      callGetFriendListApi(scaffoldKey, showLoader: true);
    });
  }

  Future<void> sendDeleteChat(String? chatID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('DELETE', Uri.parse('https://iseey.app/api/app/socket/deleteChat/$chatID'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  Future<bool>? callUnFriendUser(GlobalKey<ScaffoldState> scaffoldKey, String strId) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'friends/unfriend/$strId',
      method: RequestMethodType.DELETE,
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

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        if (success == 200) {
          callGetFriendListApi(scaffoldKey, showLoader: true);
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

  @override
  Widget build(BuildContext context) {
    bool isReload = Provider.of<StateManagement>(context).isReload ?? false;
    if (isReload) {
      callRebuild();
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetsConstant.chatBackground2,
            fit: BoxFit.cover,
          ),
          ColoredBox(color: Colors.black87),
          SafeArea(
            child: isReload
                ? SizedBox.shrink()
                : Container(
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
                                    AssetsConstant.bars,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                onPressed: () => mainTabsScaffoldKey.currentState?.openDrawer(),
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
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 20),
                                height: 45,
                                width: double.infinity,
                                child: GlobalWidgets.setText(
                                  L10n.current.friends_page_chats_title,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  strTextColor: AppColors.strMainTextColorWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        chatUserListResult.length == 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: Center(
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    child: Center(
                                      child: Text(
                                        L10n.current.friends_page_no_chats_available_title,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: Container(
                                  child: ListView.builder(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                    itemCount: chatUserListResult.isEmpty ? 0 : chatUserListResult.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      ChatUserResult? friend = chatUserListResult[index];

                                      return friend.userDetail.isBlocked
                                          ? Container(
                                              padding: EdgeInsets.fromLTRB(8, 25, 8, 0),
                                              child: GlobalWidgets.setText(
                                                L10n.current.no_chats_connection,
                                                strTextColor: AppColors.strMainTextColorWhite,
                                                textAlign: TextAlign.center,
                                                fontSize: 18,
                                                maxLine: 2,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                FocusScope.of(context).unfocus();

                                                Map<String, dynamic> data = await getMapData("userdata");
                                                UserResult userInfo = UserResult.fromJson(data);
                                                Navigator.push(
                                                  mainTabsScaffoldKey.currentContext ?? context,
                                                  SlideLeftRoute(
                                                    page: ChatScreen(
                                                      fromUser: userInfo,
                                                      toUser: friend.userDetail,
                                                      chatId: friend.chatId,
                                                      restaurant: friend.restaurant,
                                                    ),
                                                    routeName: "/chat",
                                                  ),
                                                ).then((value) => callGetFriendListApi(scaffoldKey, showLoader: true));
                                              },
                                              child: Container(
                                                height: 120,
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
                                                    closeOnScroll: true,
                                                    useTextDirection: false,
                                                    endActionPane: ActionPane(
                                                      motion: ScrollMotion(),
                                                      extentRatio: 0.24,
                                                      children: [
                                                        CustomSlidableAction(
                                                          backgroundColor: AppColors.listBoxBackgroundColor,
                                                          onPressed: (BuildContext? context) {},
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
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                globalWidget.showPopUpWithMessage(
                                                                  context:
                                                                      mainTabsScaffoldKey.currentContext ?? context,
                                                                  conditionButtonEnable: true,
                                                                  titleMessage: L10n.current.app_name,
                                                                  onPressOKButton: () async {
                                                                    await sendDeleteChat(friend.chatId);
                                                                    callGetFriendListApi(scaffoldKey, showLoader: true);
                                                                  },
                                                                  message: L10n
                                                                      .current.friends_page_delete_chat_warning_message,
                                                                );
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
                                                                shadowDarkColorEmboss:
                                                                    AppColors.mainBackgroundColorOrange,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: chatUserListResult.length == 0
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
                                                                        padding: EdgeInsets.symmetric(vertical: 40),
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
                                                                                strTextColor:
                                                                                    AppColors.strMainTextColorWhite,
                                                                                textAlign: TextAlign.center,
                                                                                fontSize: 26,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: GlobalWidgets.setText(
                                                                                L10n.current.blocked_user_no_data_title,
                                                                                strTextColor:
                                                                                    AppColors.strMainTextColorWhite,
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
        ],
      ),
    );
  }

  setListItem(int index) {
    ChatUserResult friend = chatUserListResult[index];

    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: friend.userDetail.image.isEmpty
                      ? Container(
                          height: 40,
                          width: 40,
                          child: GFAvatar(
                            backgroundColor: Colors.white.withOpacity(0.5),
                            maxRadius: 20,
                            backgroundImage: AssetImage(AssetsConstant.manPlaceholder),
                            shape: GFAvatarShape.circle,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: friend.userDetail.image,
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
                                backgroundImage: AssetImage(AssetsConstant.manPlaceholder),
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
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                      child: GlobalWidgets.setText(
                        friend.userDetail.firstName + " " + friend.userDetail.lastName,
                        fontSize: 16,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: GlobalWidgets.setText(
                        friend.restaurant?.name ?? '',
                        maxLine: 1,
                        fontSize: 13,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
                      child: GlobalWidgets.setText(
                        friend.lastMessage?.message ?? '',
                        maxLine: 1,
                        fontSize: 12,
                        strTextColor: AppColors.strFieldShadow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            friend.messagesCount == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      maxRadius: 16,
                      backgroundColor: Colors.red,
                      child: Text(
                        friend.messagesCount > 0 ? friend.messagesCount.toString() : "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
