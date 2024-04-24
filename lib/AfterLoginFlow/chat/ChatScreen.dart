import 'dart:async';
import 'dart:convert';

import 'package:ISEEY/AfterLoginFlow/chat/widgets/left_chat_bubble.dart';
import 'package:ISEEY/AfterLoginFlow/chat/widgets/pop_over_button.dart';
import 'package:ISEEY/AfterLoginFlow/chat/widgets/right_chat_bubble.dart';
import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/TableListModel.dart';
import 'package:ISEEY/Models/UserModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/ChatController.dart';
import 'package:ISEEY/Services/SocketUtils.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';

import '../ProfileScreen.dart';

class ChatScreen extends StatefulWidget {
  final UserResult fromUser;
  final UserDetail toUser;
  final String chatId;
  final Restaurant? restaurant;
  ChatScreen({Key? key, required this.fromUser, required this.toUser, required this.chatId, this.restaurant}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController messageBoxController = TextEditingController();
  List<Map> _chatDataList = [];
  ChatListController _chatListController = Get.put(ChatListController());
  ScrollController _controller = ScrollController();

  String chatBackgroundPath = AssetsConstant.chatBackgroundGray;
  bool tick = false;
  late UserDetail toUser;
  UserResult? localUser;

  void loadLocalUserData() async {
    Map<String, dynamic> data = await getMapData("userdata");
    localUser = UserResult.fromJson(data);
  }

  @override
  void initState() {
    super.initState();
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);
    loadLocalUserData();
    toUser = widget.toUser;

    globalChatUserId = widget.toUser.userId;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _connectSocket();
      callGetAllMessageApi();
      callUpdateUser();
    });
  }

  @override
  void dispose() {
    _chatListController.chatData.clear();
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    globalChatUserId = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        if (!GlobalWidgets.socketUtils.socket.connected) {
          Navigator.pop(context);
          _chatListController.chatData.clear();
          globalChatUserId = null;
        }
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;

      default:
        break;
    }
  }

  clearChatDataList() {
    setState(() {
      _chatDataList.clear();
    });
  }

  Future<bool> callGetAllMessageApi() async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'socket/getMessages/${widget.chatId}?limit=1000',
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

      Future.delayed(const Duration(milliseconds: 800), () {
        x.hideLoading();
        if (mounted) setState(() {});
      });

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        int success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success == 200) {
          List<dynamic> list = jsonRes["result"];
          list.reversed.forEach((element) {
            if (widget.fromUser.userId != element["sender"]) {
              _chatDataList.add(
                {
                  "id": element['_id'],
                  "isRight": false,
                  "nameText": toUser.firstName,
                  "timeText": element["created"],
                  "chatText": element["message"],
                  "imgPath": toUser.image,
                },
              );
              _chatListController.addMsgToList(
                {
                  "id": element['_id'],
                  "isRight": false,
                  "nameText": toUser.firstName,
                  "timeText": element["created"],
                  "chatText": element["message"],
                  "imgPath": toUser.image,
                },
              );
            } else {
              _chatDataList.add(
                {
                  "id": element['_id'],
                  "isRight": true,
                  "nameText": widget.fromUser.firstName,
                  "timeText": element["created"],
                  "chatText": element["message"],
                  "imgPath": widget.fromUser.image,
                },
              );
              _chatListController.addMsgToList(
                {
                  "id": element['_id'],
                  "isRight": true,
                  "nameText": widget.fromUser.firstName,
                  "timeText": element["created"],
                  "chatText": element["message"],
                  "imgPath": widget.fromUser.image,
                },
              );
            }
          });
          setState(() {});
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

  _connectSocket() async {
    await GlobalWidgets.initSocket();
    await GlobalWidgets.socketUtils.initSocket(widget.fromUser, widget.chatId);
    GlobalWidgets.socketUtils.connectToSocket();
    GlobalWidgets.socketUtils.setConnectListener(onConnect);
    GlobalWidgets.socketUtils.setOnDisconnectListener(onDisconnect);
    GlobalWidgets.socketUtils.setOnCustomErrorListener(onCustomError);
    GlobalWidgets.socketUtils.setOnChatMessageReceivedListener(setOnChatMessageReceivedListener);

    GlobalWidgets.socketUtils.sendJoinRoom(
      isChatId: true,
      chatId: widget.chatId,
    );

    GlobalWidgets.socketUtils.setOnConnectionErrorListener(onConnectError);
    checkISSocketConnected();
    GlobalWidgets.socketUtils.updateSeenCounts(widget.chatId);
  }

  setOnChatMessageReceivedListener(data) {
    debugPrint("data ===> $data");
    if (localUser?.userId == data['sender']) {
      return;
    }
    if (!mounted) return;
    setState(() {
      if (widget.fromUser.userId != data["sender"]) {
        _chatDataList.add(
          {
            "isRight": false,
            "nameText": toUser.firstName,
            "timeText": data["created"],
            "chatText": data["message"],
            "imgPath": toUser.image,
          },
        );
        _chatListController.addMsgToList({
          "isRight": false,
          "nameText": toUser.firstName,
          "timeText": data["created"],
          "chatText": data["message"],
          "imgPath": toUser.image,
        });
      } else {
        _chatDataList.add(
          {
            "isRight": true,
            "nameText": widget.fromUser.firstName,
            "timeText": data["created"],
            "chatText": data["message"],
            "imgPath": widget.fromUser.image,
          },
        );
        _chatListController.addMsgToList({
          "isRight": true,
          "nameText": widget.fromUser.firstName,
          "timeText": data["created"],
          "chatText": data["message"],
          "imgPath": widget.fromUser.image,
        });
      }
    });
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  onCustomError(data) {
    debugPrint('Custom Error $data');
  }

  onConnect(data) {
    debugPrint('Connected $data');
    if (!mounted) return;
    setState(() {});
  }

  onDisconnect(data) {
    debugPrint('onDisconnect $data');
    if (!mounted) return;
    setState(() {});
  }

  onConnectError(data) {
    debugPrint('onConnectError $data');
    if (!mounted) return;
    setState(() {});
  }

  onConnectTimeout(data) {
    debugPrint('onConnectTimeout $data');
    setState(() {});
  }

  onError(data) {
    debugPrint('onError $data');
    setState(() {});
  }

  checkISSocketConnected() {
    bool isConnected = GlobalWidgets.socketUtils.socket.connected;
    debugPrint('checkISSocketConnected $isConnected');
  }

  @override
  Widget build(BuildContext context) {
    if (_chatDataList.length > 5)
      Timer(
        Duration(milliseconds: 300),
        () => _controller.jumpTo(_controller.position.maxScrollExtent),
      );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                          try {
                            GlobalWidgets.socketUtils.updateSeenCounts(widget.chatId);
                          } catch (e) {}
                          Navigator.pop(context);
                          _chatListController.chatData.clear();
                          globalChatUserId = '';
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
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10, left: 10),
                        height: 45,
                        width: screenSize.width,
                        child: Column(
                          children: [
                            GlobalWidgets.setText(
                              '${widget.toUser.firstName} ${widget.toUser.lastName}',
                              maxLine: 1,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              strTextColor: AppColors.strMainTextColorWhite,
                            ),
                            if (widget.restaurant != null) Container(height: 4),
                            if (widget.restaurant != null)
                              GlobalWidgets.setText(
                                '${widget.restaurant?.name}',
                                textAlign: TextAlign.center,
                                maxLine: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                strTextColor: AppColors.strMainTextColorGrey,
                              ),
                          ],
                        ),
                      ),
                    ),
                    PopOverButton(onTap: () {
                      FocusScope.of(context).unfocus();
                      showPopover(
                        backgroundColor: AppColors.listBoxBackgroundColor,
                        context: context,
                        bodyBuilder: (context) => ListItems(
                          self: this,
                        ),
                        onPop: () => debugPrint('Popover was popped!'),
                        direction: PopoverDirection.top,
                        width: 180,
                        height: 200,
                        arrowHeight: 20,
                        arrowWidth: 30,
                        barrierColor: Colors.transparent,
                      );
                    }),
                  ],
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: double.infinity,
                    height: double.infinity,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: -3,
                        lightSource: LightSource.top,
                        color: Colors.transparent,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 1,
                        ),
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: Colors.transparent,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            child: Image.asset(
                              chatBackgroundPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(color: Colors.black54),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Obx(() {
                                  return Container(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(top: 20, bottom: 0),
                                      controller: _controller,
                                      itemCount: _chatListController.chatData.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onLongPress: () {
                                            getActionSheet(_chatListController.chatData[index]['id']);
                                          },
                                          child: _chatListController.chatData[index]["isRight"]
                                              ? RightChatBubble(
                                                  imgPath: _chatListController.chatData[index]["imgPath"],
                                                  nameText: _chatListController.chatData[index]["nameText"],
                                                  timestamp: _chatListController.chatData[index]["timeText"],
                                                  chatText: _chatListController.chatData[index]["chatText"],
                                                )
                                              : LeftChatBubble(
                                                  imgPath: _chatListController.chatData[index]["imgPath"],
                                                  nameText: _chatListController.chatData[index]["nameText"],
                                                  timestamp: _chatListController.chatData[index]["timeText"],
                                                  chatText: _chatListController.chatData[index]["chatText"],
                                                ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  bottom: 15,
                                  top: 15,
                                ),
                                width: double.infinity,
                                child: Neumorphic(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(2),
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
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                          child: TextField(
                                            maxLines: 6,
                                            minLines: 1,
                                            textCapitalization: TextCapitalization.sentences,
                                            style: TextStyle(
                                              color: AppColors.mainTextColorWhite,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            controller: messageBoxController,
                                            keyboardAppearance: Brightness.dark,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: AppColors.fieldShadow,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                              ),
                                              hintText: L10n.current.chat_page_send_message_title,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: NeumorphicButton(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          child: Center(
                                            child: Image.asset(
                                              AssetsConstant.sendMessageIcon,
                                              fit: BoxFit.contain,
                                              color: AppColors.mainBackgroundColorOrange,
                                            ),
                                          ),
                                          onPressed: () {
                                            sendMessage();
                                            _controller.jumpTo(
                                              _controller.position.maxScrollExtent,
                                            );
                                          },
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    if (!mounted && messageBoxController.text.isEmpty) return;
    GlobalWidgets.socketUtils.sendSingleChatMessage(
      messageBoxController.text.trim(),
      toUser,
    );

    setState(() {
      _chatDataList.insert(
        0,
        {
          "isRight": true,
          "nameText": widget.fromUser.firstName,
          "timeText": getTimeInCustomFormat(),
          "chatText": messageBoxController.text,
          "imgPath": widget.fromUser.image,
        },
      );

      _chatListController.addMsgToList({
        "isRight": true,
        "nameText": widget.fromUser.firstName,
        "timeText": DateTime.now().millisecondsSinceEpoch,
        "chatText": messageBoxController.text,
        "imgPath": widget.fromUser.image,
      });

      messageBoxController.clear();
    });
  }

  getActionSheet(String? id) {
    _containerForSheet<String>(
      child: CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: GlobalWidgets.setText(
                L10n.current.chat_page_delete_title,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                strTextColor: AppColors.strMainBackgroundColorOrange,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop("Delete");
                SocketUtils().sendDeleteMessage(id ?? '');
                _chatListController.chatData.forEach((element) {
                  if (element["id"] == id) {
                    _chatListController.chatData.remove(element);
                  }
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: GlobalWidgets.setText(
              L10n.current.cancel_button_title,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              strTextColor: AppColors.strMainBackgroundColorOrange,
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Cancel");
            },
          )),
    );
  }

  void _containerForSheet<T>({required Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (_) => child,
    ).then<void>((T? value) {
      if (value == "Delete") {}
    });
  }

  Future<bool> callUpdateUser() async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/getUserDetail/${widget.toUser.sId == '' ? toUser.userId : toUser.sId}',
        method: RequestMethodType.GET,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        UserDetail modelData = UserDetail.fromJson(jsonRes["result"]);

        if (success == 200) {
          setState(() {
            toUser = modelData;
            toUser.sId = widget.toUser.sId;
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

  Future<bool> callAddAsFriendUserApi() async {
    var data = new Map<String, dynamic>();
    data['user_id'] = toUser.sId;

    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
        url: 'friends/addFriend', method: RequestMethodType.POST, body: body, params: '', headerType: "json", authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      final context = scaffoldKey.currentContext;
      if (context != null) x.showLoading(context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success == 200) {
          showSuccessOrFail(message, success, context, isCustom: true, onCustomOkPress: () {
            callUpdateUser();
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

  Future<bool> callBlockUserApi() async {
    var data = new Map<String, dynamic>();
    data['user_id'] = toUser.sId;

    var body = json.encode(data);
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/block', method: RequestMethodType.POST, body: body, params: '', headerType: "json", authMethod: true);
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
          showSuccessOrFail(message, success, context);
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
}

class ListItems extends StatelessWidget {
  final _ChatScreenState self;
  const ListItems({Key? key, required this.self}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        child: Neumorphic(
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
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  self.toUser.isFriend
                      ? Navigator.push(
                          context,
                          SlideLeftRoute(
                            routeName: "/profileScreen",
                            page: ProfileScreen(
                              userDetail: self.toUser,
                              isFromChatScreen: true,
                            ),
                          ),
                        )
                      : self.callAddAsFriendUserApi();
                },
                child: Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: GlobalWidgets.setText(
                    self.widget.toUser.isFriend ? L10n.current.chat_page_view_profile_title : L10n.current.chat_page_add_friend_title,
                    fontSize: 14,
                    strTextColor: AppColors.strMainTextColorWhite,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  globalWidget.showPopUpWithMessage(
                      context: mainTabsScaffoldKey.currentContext ?? context,
                      conditionButtonEnable: true,
                      titleMessage: "ISEEY",
                      onPressOKButton: () {
                        self.callBlockUserApi();
                      },
                      message: L10n.current.chat_page_block_user_warning_message);
                },
                child: Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: GlobalWidgets.setText(
                    L10n.current.chat_page_block_user_title,
                    fontSize: 14,
                    strTextColor: AppColors.strMainTextColorWhite,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  globalWidget.showPopUpWithMessage(
                      context: mainTabsScaffoldKey.currentContext ?? context,
                      conditionButtonEnable: true,
                      titleMessage: "ISEEY",
                      withTextField: true,
                      onPressOKButton: () => self.callBlockUserApi(),
                      message: L10n.current.chat_page_flag_user_warning_message);
                },
                child: Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: GlobalWidgets.setText(
                    L10n.current.chat_page_flag_user_title,
                    fontSize: 14,
                    strTextColor: AppColors.strMainTextColorWhite,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();

                  globalWidget.showPopUpWithMessage(
                      context: mainTabsScaffoldKey.currentContext ?? context,
                      conditionButtonEnable: true,
                      titleMessage: "ISEEY",
                      onPressOKButton: () {
                        GlobalWidgets.socketUtils.sendClearChat(self.widget.chatId);
                        self._chatListController.clearChat();
                        self.clearChatDataList();
                      },
                      message: L10n.current.chat_page_clear_chat_warning_message);
                },
                child: Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 10),
                  child: GlobalWidgets.setText(
                    L10n.current.chat_page_clear_chat_title,
                    fontSize: 14,
                    strTextColor: AppColors.strMainTextColorWhite,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
