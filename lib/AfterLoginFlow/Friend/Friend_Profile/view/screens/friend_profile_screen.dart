import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/domain/profile_repository.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/action_button.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/back_button.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/friend_profile_image.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/friend_profile_name.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/profil_info_item.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/widgets/friend_profile_title.dart';
import 'package:iseey/AfterLoginFlow/chat/view/chat_screen.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class FriendProfileScreen extends StatefulWidget {
  final UserDetail userDetail;
  final bool isFromChatScreen;

  const FriendProfileScreen({
    Key? key,
    required this.userDetail,
    this.isFromChatScreen = false,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<FriendProfileScreen> {
  String profileImage = '';
  String strDob = '';
  String description = '';
  String chatId = '';
  List<ChatUserResult> chatUserListResult = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = ProfileRepository(scaffoldKey);
    profileImage = widget.userDetail.image;
    strDob = _repository.formatUserDob(widget.userDetail.dob);
    description = widget.userDetail.description;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFriendList();
    });
  }

  Future<void> _loadFriendList() async {
    final friends = await _repository.getFriendList();
    if (mounted) {
      setState(() {
        chatUserListResult = friends;
      });
    }
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
                  Backbutton(context: context),
                  FriendProfileTitle(),
                ],
              ),
              FriendProfileImage(profileImage: profileImage),
              FriendProfileName(userDetail: widget.userDetail),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileInfoItem(
                        icon: AssetsConstant.userIcon,
                        title: L10n.current.menu_friends_title,
                        value: widget.userDetail.friendsCount.toString(),
                      ),
                      ProfileInfoItem(
                        icon: AssetsConstant.calendar,
                        title: L10n.current.profile_page_birth_date_title,
                        value: strDob,
                      ),
                      if (description.isNotEmpty)
                        ProfileInfoItem(
                          icon: AssetsConstant.info,
                          title: description,
                          isDescription: true,
                        ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ActionButton(
                              text: widget.userDetail.isBlocked
                                  ? L10n.current.profiel_page_unblock_user_action_title
                                  : L10n.current.profiel_page_block_user_action_title,
                              onPressed: _handleBlockAction,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ActionButton(
                              text: L10n.current.profiel_page_message_title,
                              onPressed: _handleMessageAction,
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

 void _handleBlockAction() {
  globalWidget.showPopUpWithMessage(
    isTitleEnable: false,
    context: scaffoldKey.currentContext ?? context,
    conditionButtonEnable: true,
    onPressOKButton: () async {
      bool success = widget.userDetail.isBlocked
          ? await _repository.unblockUser(widget.userDetail.userId)
          : await _repository.blockUser(widget.userDetail.userId);
      Navigator.of(context).pop();

      if (success && mounted) {
        showSuccessOrFail(
          widget.userDetail.isBlocked 
              ?    "User blocked successfully"
              :    "User unblocked successfully",
          true,
          context,
          isTitleEnable: true,
        );
        setState(() {
          widget.userDetail.isBlocked = !widget.userDetail.isBlocked;
        });
      }
    },
    titleMessage: L10n.current.app_name,
    message: widget.userDetail.isBlocked
        ? L10n.current.blocked_user_unblock_user_warning_message
        : L10n.current.chat_page_block_user_warning_message,
  );
}

  void _handleMessageAction() async {
    if (widget.isFromChatScreen) {
      Navigator.pop(context);
    } else {
      String? chatId = await _repository.createOrGetChat(widget.userDetail.userId);
      if (chatId != null && mounted) {
        _navigateToChatScreen(chatId);
      }
    }
  }

  void _navigateToChatScreen(String chatId) {
    Navigator.push(
      mainTabsScaffoldKey.currentContext ?? context,
      SlideLeftRoute(
        routeName: "/chat",
        page: ChatScreen(
          fromUser: UserResult.fromJson(getMapData("userdata")),
          toUser: widget.userDetail,
          chatId: chatId,
        ),
      ),
    );
  }
}
