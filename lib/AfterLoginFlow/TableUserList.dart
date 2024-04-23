import 'dart:convert';

import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/TableListModel.dart';
import 'package:ISEEY/Models/UserModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getwidget/getwidget.dart';

import 'chat/ChatScreen.dart';

class TableUserList extends StatefulWidget {
  final List<TableUsers> userList;
  final Restaurant? restaurant;
  final int tableId;

  TableUserList({
    Key? key,
    required this.userList,
    required this.tableId,
    required this.restaurant,
  }) : super(key: key);

  @override
  _TableUserListState createState() => _TableUserListState();
}

class _TableUserListState extends State<TableUserList> {
  String? chatId = "";

  Future<bool> callCreateOrGetChatApi(
    GlobalKey<ScaffoldState> scaffoldKey,
    String userId,
    String restaurantId,
  ) async {
    var data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['restaurant_id'] = restaurantId;

    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
      url: 'socket/createOrGetChat',
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
                        L10n.current.table_list_table_number(' ', widget.tableId),
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
                    itemCount: widget.userList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          Map<String, dynamic> data = await getMapData("userdata");
                          UserResult userInfo = UserResult.fromJson(data);
                          TableUsers user = widget.userList[index];
                          if (userInfo.userId == user.userDetail?.sId.toString()) {
                            showSuccessOrFail(L10n.current.table_user_list_chat_with_yourself_error_message, 000, context);
                            return;
                          }
                          bool isResponseSuccess =
                              await callCreateOrGetChatApi(scaffoldKey, user.userDetail?.sId ?? '', widget.restaurant?.sId ?? '');

                          if (isResponseSuccess) {
                            Navigator.push(
                              mainTabsScaffoldKey.currentContext ?? context,
                              SlideLeftRoute(
                                routeName: "/chat",
                                page: ChatScreen(
                                  fromUser: userInfo,
                                  toUser: user.userDetail!,
                                  chatId: chatId ?? '',
                                  restaurant: widget.restaurant,
                                ),
                              ),
                            );
                          }
                        },
                        child: setListItem(index),
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
    TableUsers? user = widget.userList[index];
    String dobStr = user.userDetail?.dob ?? '';
    final String dobTest = dobStr.isEmpty ? '898108200000' : dobStr;
    final DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(dobTest));
    final int age = calculateAge(dob);
    final facebookUrl = user.userDetail?.facebookUrl ?? '';
    final instagramUrl = user.userDetail?.instagramUrl ?? '';

    return Container(
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
                      imageUrl: user.userDetail?.image ?? '',
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
                            backgroundImage: AssetImage("assets/man-placeholder.png"),
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
                          "${user.userDetail?.firstName ?? ''} ${user.userDetail?.lastName ?? ''}",
                          fontSize: 16,
                          maxLine: 2,
                          strTextColor: AppColors.strMainTextColorWhite,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: GlobalWidgets.setText(
                          user.userDetail?.description ?? '',
                          fontSize: 12,
                          maxLine: 2,
                          strTextColor: AppColors.strMainTextColorWhite,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 5, left: 20, right: 5, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              child: Image.asset(
                                AssetsConstant.instance.calendarIcon,
                                fit: BoxFit.contain,
                                color: Colors.orange,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                              child: GlobalWidgets.setText(
                                L10n.current.table_user_list_user_age(age),
                                strTextColor: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (facebookUrl.isNotEmpty)
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 10, top: 2),
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Image.asset(
                            AssetsConstant.instance.facebook,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            height: 25,
                          ),
                        ),
                        onPressed: () => launchURL(facebookUrl),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: -5,
                          lightSource: LightSource.top,
                          color: AppColors.listBoxBackgroundColor,
                          border: NeumorphicBorder(
                            color: AppColors.innerShadowColor,
                            width: 0.1,
                          ),
                          shadowDarkColor: AppColors.innerShadowColor,
                          shadowLightColorEmboss: AppColors.innerShadowColor,
                          shadowDarkColorEmboss: AppColors.innerShadowColor,
                        ),
                      ),
                    ),
                  if (instagramUrl.isNotEmpty && facebookUrl.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 2, top: 2),
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
                      width: 47,
                    ),
                  if (instagramUrl.isNotEmpty)
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 10, bottom: 2),
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Image.asset(
                            AssetsConstant.instance.instagram,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            height: 25,
                          ),
                        ),
                        onPressed: () => launchURL(instagramUrl),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: -5,
                          lightSource: LightSource.top,
                          color: AppColors.listBoxBackgroundColor,
                          border: NeumorphicBorder(
                            color: AppColors.innerShadowColor,
                            width: 0.1,
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
      ),
    );
  }
}
