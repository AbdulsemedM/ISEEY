import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/chat/controller/chat_controller.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/chats_list.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class ChatPartnerScreen extends StatefulWidget {
  @override
  _ChatPartnerScreenState createState() => _ChatPartnerScreenState();
}

class _ChatPartnerScreenState extends State<ChatPartnerScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    debugPrint("🔄 [CHAT PARTNER] Initializing ChatPartnerScreen");
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    // SocketUtils.instance.setOnChatMessageNotificationListener((data) {});
  }

  void _loadData() {
    debugPrint("🔄 [CHAT PARTNER] Loading friend list data");
    final chatController = context.read<ChatController>();
    chatController.callGetFriendListApi(
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(builder: (context, chatController, child) {
      final chatUserListResult = chatController.chatUserListResult;
      final isFriendsLoading = chatController.isFriendsLoading;

      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.screensBackgroundsColor,
          leadingWidth: 90,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NeumorphicButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                child: Image.asset(
                  AssetsConstant.bars,
                  fit: BoxFit.contain,
                ),
              ),
              onPressed: () {
                mainTabsScaffoldKey.currentState?.openDrawer();
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
        ),
        backgroundColor: AppColors.screensBackgroundsColor,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              chatController.shouldShowEmptyState
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Container(
                          height: 300,
                          width: 300,
                          child: Center(
                            child: Text(
                              L10n.current
                                  .friends_page_no_chats_available_title,
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
                  : isFriendsLoading
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.mainBackgroundColorOrange,
                              ),
                            ),
                          ),
                        )
                      : chatUserListResult.isNotEmpty
                          ? ChatsList(
                              chatUserListResult: chatUserListResult,
                              scaffoldKey: scaffoldKey,
                            )
                          : Center(
                              child: Text(
                                "No chat data available",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
            ],
          ),
        ),
      );
    });
  }
}
