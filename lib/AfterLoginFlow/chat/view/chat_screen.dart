import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/screens/friend_profile_screen.dart';
import 'package:iseey/AfterLoginFlow/chat/controller/chat_controller.dart';
import 'package:iseey/AfterLoginFlow/chat/widgets/widgets.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/GlobalFiles.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/Services.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

import '../model/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final UserResult fromUser;
  final UserDetail toUser;
  final String chatId;
  final Restaurant? restaurant;

  ChatScreen({
    Key? key,
    required this.fromUser,
    required this.toUser,
    required this.chatId,
    this.restaurant,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController messageBoxController = TextEditingController();
  // List<Map> _chatDataList = [];
  late ScrollController _controller;

  String chatBackgroundPath = AssetsConstant.chatBackgroundGray;
  bool tick = false;
  late UserDetail toUser;
  UserResult? localUser;

  var x = GlobalWidgets();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadLocalUserData();
    toUser = widget.toUser;
    _controller = ScrollController();
    globalChatUserId = widget.toUser.userId;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _connectSocket();
      context.read<ChatController>().callGetAllMessageApi(
            context: context,
            scaffoldKey: scaffoldKey,
            chatId: widget.chatId,
            toUser: widget.toUser,
            fromUser: widget.fromUser,
            localUser: localUser,
          );
      // callGetAllMessageApi();
      callUpdateUser();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    globalChatUserId = null;
    
    // Clear current chat info when leaving chat screen
    context.read<ChatController>().clearCurrentChat();
    
    _controller.dispose();

    // Clean up socket listeners to prevent callbacks after disposal
    try {
      SocketUtils.instance.socket.off(SocketUtils.ON_MESSAGE_RECEIVED);
    } catch (e) {
      debugPrint("Error removing socket listener: $e");
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (!SocketUtils.instance.socket.connected) {
          Navigator.pop(context);
          globalChatUserId = null;
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void loadLocalUserData() async {
    Map<String, dynamic> data = await getMapData("userdata");
    localUser = UserResult.fromJson(data);
  }

  // void clearChatDataList() => setState(() => _chatDataList.clear());

  // Future<bool> callGetAllMessageApi() async {
  //   HttpRequestModel req = HttpRequestModel(
  //     url: 'socket/getMessages/${widget.chatId}?limit=1000',
  //     method: RequestMethodType.GET,
  //     body: '',
  //     params: '',
  //     headerType: "json",
  //     authMethod: true,
  //   );
  //   var response;
  //   var x = GlobalWidgets();
  //   try {
  //     x.showLoading(scaffoldKey.currentContext ?? context);
  //     response = await HttpService().init(req, scaffoldKey);

  //     Future.delayed(const Duration(milliseconds: 800), () {
  //       x.hideLoading();
  //       if (mounted) setState(() {});
  //     });

  //     if (response is String && response != '') {
  //       var jsonRes = jsonDecode(response);

  //       bool success = jsonRes["success"] ?? false;
  //       String message = jsonRes["message"];

  //       if (success) {
  //         List<dynamic> list = jsonRes["data"] ?? [];
  //         List<ChatMessage> chatMessages =
  //             (list).map((item) => ChatMessage.fromJson(item)).toList();
  //         chatMessages.reversed.forEach((element) {
  //           // Check if the message is deleted for the current user
  //           if (element.deletedForUser.contains(localUser?.userId ?? '')) {
  //             return; // Skip this message if it's deleted for the user
  //           }
  //           if (widget.fromUser.userId != element.sender) {
  //             _chatDataList.add({
  //               "id": element.id,
  //               "isRight": false,
  //               "nameText": toUser.firstName,
  //               "timeText": element.created,
  //               "chatText": element.message,
  //               "imgPath": toUser.image,
  //             });
  //             _chatListController.addMsgToList({
  //               "id": element.id,
  //               "isRight": false,
  //               "nameText": toUser.firstName,
  //               "timeText": element.created,
  //               "chatText": element.message,
  //               "imgPath": toUser.image,
  //             });
  //           } else {
  //             _chatDataList.add({
  //               "id": element.id,
  //               "isRight": true,
  //               "nameText": widget.fromUser.firstName,
  //               "timeText": element.created,
  //               "chatText": element.message,
  //               "imgPath": widget.fromUser.image,
  //             });
  //             _chatListController.addMsgToList({
  //               "id": element.id,
  //               "isRight": true,
  //               "nameText": widget.fromUser.firstName,
  //               "timeText": element.created,
  //               "chatText": element.message,
  //               "imgPath": widget.fromUser.image,
  //             });
  //           }
  //         });
  //         setState(() {});
  //         return true;
  //       } else {
  //         showSuccessOrFail(message, false, context);
  //         return false;
  //       }
  //     } else {
  //       showSuccessOrFail(L10n.current.something_went_wrong, false, context);
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("EXCEPTION $e");
  //   }

  //   x.hideLoading();
  //   return false;
  // }

  void _connectSocket() async {
    // await GlobalWidgets.initSocket();
    SocketUtils.instance.initChatSocket(widget.fromUser, widget.chatId);
    SocketUtils.instance
        .setOnChatMessageReceivedListener(setOnChatMessageReceivedListener);
    // await GlobalWidgets.socketUtils.initSocket(widget.fromUser, widget.chatId);
    // GlobalWidgets.socketUtils.connectToSocket();
    // GlobalWidgets.socketUtils.setConnectListener(onConnect);
    // GlobalWidgets.socketUtils.setOnDisconnectListener(onDisconnect);
    // GlobalWidgets.socketUtils.setOnCustomErrorListener(onCustomError);
    // GlobalWidgets.socketUtils
    //     .setOnChatMessageReceivedListener(setOnChatMessageReceivedListener);

    SocketUtils.instance.sendJoinRoom(
      isChatId: true,
      chatId: widget.chatId,
    );

    // GlobalWidgets.socketUtils.setOnConnectionErrorListener(onConnectError);
    checkISSocketConnected();
    SocketUtils.instance.updateSeenCounts(widget.chatId);
  }

  void setOnChatMessageReceivedListener(data) {
    debugPrint("data ===> $data");
    if (localUser?.userId == data['sender']) {
      return;
    }

    if (!mounted) return;

    final chatController = context.read<ChatController>();
    if (widget.fromUser.userId != data["sender"]) {
      final chatModel = ChatModel(
        id: data["_id"],
        nameText: toUser.firstName,
        timeText: data["created"],
        chatText: data["message"],
        imgPath: toUser.image,
        isRight: false,
      );
      chatController.saveChatMessage(chat: chatModel);
    } else {
      final chatModel = ChatModel(
        id: data["_id"],
        nameText: widget.fromUser.firstName,
        timeText: data["created"],
        chatText: data["message"],
        imgPath: widget.fromUser.image,
        isRight: true,
      );
      chatController.saveChatMessage(chat: chatModel);
    }
    if (mounted && _controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void onCustomError(data) {
    debugPrint('Custom Error $data');
  }

  void onConnect(data) {
    debugPrint('Connected $data');
    if (!mounted) return;
    setState(() {});
  }

  void onDisconnect(data) {
    debugPrint('onDisconnect $data');
    if (!mounted) return;
    setState(() {});
  }

  void onConnectError(data) {
    debugPrint('onConnectError $data');
    if (!mounted) return;
    setState(() {});
  }

  void checkISSocketConnected() {
    bool isConnected = SocketUtils.instance.socket.connected;
    debugPrint('checkISSocketConnected $isConnected');
  }

  void sendMessage() async {
    if (!mounted || messageBoxController.text.isEmpty) return;
    final message = messageBoxController.text.trim();
    SocketUtils.instance.sendSingleChatMessage(
      message,
      toUser,
    );
    final chatController = context.read<ChatController>();
    final chatModel = ChatModel(
      id: '',
      nameText: widget.fromUser.firstName,
      timeText: DateTime.now().millisecondsSinceEpoch,
      chatText: message,
      imgPath: widget.fromUser.image,
      isRight: true,
    );
    chatController.saveChatMessage(chat: chatModel);

    setState(() {
      messageBoxController.clear();
    });
    if (mounted && _controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // App Bar
                Row(
                  children: [
                    // Back Button
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
                          SocketUtils.instance.updateSeenCounts(widget.chatId);
                          context.read<ChatController>().clearCurrentChat();
                          Navigator.pop(context);
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
                    // User Info
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
                    // Popover Menu
                    PopOverButton(onTap: () async {
                      FocusScope.of(context).unfocus();
                      await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 120, 0, 0),
                        color: AppColors.listBoxBackgroundColor,
                        items: [
                          PopupMenuItem(
                            onTap: () {
                              toUser.isFriend
                                  ? Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        routeName: "/profileScreen",
                                        page: FriendProfileScreen(
                                          userDetail: toUser,
                                          isFromChatScreen: true,
                                        ),
                                      ),
                                    )
                                  : callAddAsFriendUserApi();
                            },
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.only(top: 10),
                              child: GlobalWidgets.setText(
                                toUser.isFriend
                                    ? L10n.current.chat_page_view_profile_title
                                    : L10n.current.chat_page_add_friend_title,
                                fontSize: 14,
                                strTextColor: AppColors.strMainTextColorWhite,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              globalWidget.showPopUpWithMessage(
                                context: mainTabsScaffoldKey.currentContext ??
                                    context,
                                conditionButtonEnable: true,
                                titleMessage: "ISEEY",
                                onPressOKButton: () => callBlockUserApi(),
                                message: L10n.current
                                    .chat_page_block_user_warning_message,
                              );
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
                          PopupMenuItem(
                            onTap: () {
                              globalWidget.showPopUpWithMessage(
                                context: mainTabsScaffoldKey.currentContext ??
                                    context,
                                conditionButtonEnable: true,
                                titleMessage: "ISEEY",
                                withTextField: true,
                                onPressOKButton: () => callBlockUserApi(),
                                message: L10n.current
                                    .chat_page_flag_user_warning_message,
                              );
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
                          PopupMenuItem(
                            onTap: () {
                              globalWidget.showPopUpWithMessage(
                                context: mainTabsScaffoldKey.currentContext ??
                                    context,
                                conditionButtonEnable: true,
                                titleMessage: "ISEEY",
                                onPressOKButton: () {
                                  SocketUtils.instance
                                      .sendClearChat(widget.chatId);
                                  if (mounted) {
                                    context
                                        .read<ChatController>()
                                        .clearChatData();
                                  }
                                },
                                message: L10n.current
                                    .chat_page_clear_chat_warning_message,
                              );
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
                        ],
                      );
                    }),
                  ],
                ),
                // Chat Messages
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
                                child: Container(
                                  child: _buildChatList(),
                                ),
                              ),
                              // Message Input Box
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
                                    shadowDarkColorEmboss:
                                        AppColors.innerShadowColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 5, 0),
                                          child: TextField(
                                            maxLines: 6,
                                            minLines: 1,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            style: TextStyle(
                                              color:
                                                  AppColors.mainTextColorWhite,
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
                                              hintText: L10n.current
                                                  .chat_page_send_message_title,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Send Button
                                      Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: NeumorphicButton(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          child: Center(
                                            child: Image.asset(
                                              AssetsConstant.sendMessageIcon,
                                              fit: BoxFit.contain,
                                              color: AppColors
                                                  .mainBackgroundColorOrange,
                                            ),
                                          ),
                                          onPressed: () {
                                            sendMessage();
                                          },
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.concave,
                                            depth: 1,
                                            lightSource: LightSource.top,
                                            color: AppColors.mainTextColorBlack
                                                .withOpacity(0.7),
                                            border: NeumorphicBorder(
                                              color: AppColors.innerShadowColor,
                                              width: 2,
                                            ),
                                            shadowDarkColor: AppColors
                                                .mainBackgroundColorOrange,
                                            shadowLightColorEmboss:
                                                Colors.transparent,
                                            shadowDarkColorEmboss:
                                                AppColors.innerShadowColor,
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

  Widget _buildChatList() {
    return Consumer<ChatController>(
      builder: (context, chatController, child) {
        final _list = chatController.chatDataList;
        final _loading = chatController.isLoading;
        if (_loading) {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (_list.isNotEmpty && !_loading) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 20, bottom: 0),
            controller: _controller,
            itemCount: _list.length,
            itemBuilder: (context, index) {
              final message = _list[index];

              // Check if we should show a date divider
              bool showDateDivider = index == 0 ||
                  !_isSameDay(_list[index - 1].timeText, message.timeText);

              return Column(
                children: [
                  if (showDateDivider) _buildDateDivider(message.timeText),
                  GestureDetector(
                    onLongPress: () {
                      getActionSheet(message.id);
                    },
                    onTap: () {
                      context.read<ChatController>().toggleShowTime(message.id);
                    },
                    child: Column(
                      children: [
                        message.isRight
                            ? RightChatBubble(
                                imgPath: message.imgPath,
                                nameText: message.nameText,
                                timestamp: message.timeText,
                                chatText: message.chatText,
                              )
                            : LeftChatBubble(
                                imgPath: message.imgPath,
                                nameText: message.nameText,
                                timestamp: message.timeText,
                                chatText: message.chatText,
                              ),
                        if (message.showTime)
                          Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              _formatTime(message.timeText),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

        return Center(
          child: GlobalWidgets.setText(
            L10n.current.no_chats_connection,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            strTextColor: AppColors.strMainTextColorGrey,
          ),
        );
      },
    );
  }

  Widget _buildDateDivider(int timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800]!.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(timestamp),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(int timestamp1, int timestamp2) {
    final date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
    final date2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('h:mm a').format(date);
  }

  void getActionSheet(String? id) {
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
                SocketUtils.instance.sendDeleteMessage(id ?? '');
                if (mounted) {
                  context.read<ChatController>().removeChatMessage(id ?? '');
                }
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
    HttpRequestModel req = HttpRequestModel(
      url:
          'users/getUserDetail/${widget.toUser.sId == '' ? toUser.userId : toUser.sId}',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      var response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        bool success = false;
        if (jsonRes["success"] is bool) {
          success = jsonRes["success"];
        } else if (jsonRes["success"] is int) {
          success = jsonRes["success"] == 1;
        }

        if (success) {
          UserDetail modelData = UserDetail.fromJson(jsonRes["result"]);
          setState(() {
            toUser = modelData;
            toUser.sId = widget.toUser.sId;
          });
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error in callUpdateUser: ${e.toString()}");
    }
    return false;
  }

  Future<bool> callAddAsFriendUserApi() async {
    var data = Map<String, dynamic>();
    data['user_id'] = toUser.sId;

    var body = json.encode(data);

    HttpRequestModel req = HttpRequestModel(
      url: 'friends',
      method: RequestMethodType.POST,
      body: body,
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final context = scaffoldKey.currentContext;
      if (context != null) {
        x.showLoading(context);
      }

      var response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);

        bool success = (jsonRes["success"] == true) ||
            (jsonRes["success"] == 1) ||
            (jsonRes["success"] == 200);

        if (success) {
          setState(() {
            toUser.isFriend = true;
          });

          if (context != null) {
            showSuccessOrFail(
              jsonRes["message"] ?? "Friend added successfully",
              true,
              context,
              isCustom: true,
              onCustomOkPress: () {
                callUpdateUser();
              },
            );
          }
          return true;
        } else {
          if (context != null) {
            showSuccessOrFail(
                jsonRes["message"] ?? "Failed to add friend", false, context);
          }
          return false;
        }
      }
    } catch (e) {
      debugPrint("Friend add error: $e");
      x.hideLoading();
      if (mounted && scaffoldKey.currentContext != null) {
        showSuccessOrFail(
            "Error adding friend", false, scaffoldKey.currentContext!);
      }
    }

    return false;
  }

  Future<bool> callBlockUserApi() async {
    var data = Map<String, dynamic>();
    data['user_id'] = toUser.userId;

    var body = json.encode(data);
    HttpRequestModel req = HttpRequestModel(
      url: 'users/block',
      method: RequestMethodType.PUT,
      body: body,
      params: '',
      headerType: "json",
      authMethod: true,
    );
    var response;
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        bool success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success) {
          showSuccessOrFail(message, true, context);
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
}
