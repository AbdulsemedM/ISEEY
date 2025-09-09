import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:iseey/AfterLoginFlow/chat/controller/chat_controller.dart';
import 'package:iseey/AfterLoginFlow/chat/view/chat_screen.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/chat_friend.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({
    super.key,
    required this.chatUserListResult,
    required this.scaffoldKey,
  });
  final List<ChatUserResult> chatUserListResult;
  final GlobalKey<ScaffoldState> scaffoldKey;

  void _loadData(BuildContext context) {
    debugPrint("🔄 [CHAT PARTNER] Loading friend list data");
    final chatController = context.read<ChatController>();
    chatController.callGetFriendListApi(
      scaffoldKey: scaffoldKey,
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    debugPrint("🔄 [CHAT PARTNER] Manual refresh triggered");
    _loadData(context);
    // Wait a bit for the API call to complete
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          itemCount: chatUserListResult.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            ChatUserResult? friend = chatUserListResult[index];

            return friend.userDetail.isBlocked
                ? SizedBox.shrink()
                : GestureDetector(
                    onTap: () async {
                      debugPrint(
                          "🔴 Socket connection error: ${friend.chatId}");
                      FocusScope.of(context).unfocus();
                      context.read<ChatController>().setChatId(friend.chatId);

                      Map<String, dynamic> data = await getMapData("userdata");
                      UserResult userInfo = UserResult.fromJson(data);
                      context.read<ChatController>().callGetFriendListApi(
                            scaffoldKey: scaffoldKey,
                          );
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
                      );
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
                                backgroundColor:
                                    AppColors.listBoxBackgroundColor,
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
                                        context: mainTabsScaffoldKey
                                                .currentContext ??
                                            context,
                                        conditionButtonEnable: true,
                                        titleMessage: L10n.current.app_name,
                                        onPressOKButton: () async {
                                          await context
                                              .read<ChatController>()
                                              .sendDeleteChat(
                                                scaffoldKey: scaffoldKey,
                                                chatID: friend.chatId,
                                              );
                                        },
                                        message: L10n.current
                                            .friends_page_delete_chat_warning_message,
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
                                      shadowDarkColor:
                                          AppColors.innerShadowColor,
                                      shadowLightColorEmboss:
                                          Colors.transparent,
                                      shadowDarkColorEmboss:
                                          AppColors.mainBackgroundColorOrange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: ChatFriend(friend: friend),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
