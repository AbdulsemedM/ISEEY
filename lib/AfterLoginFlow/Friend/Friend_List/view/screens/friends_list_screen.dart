import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/domain/FriendList_Model/FriendListModel.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/domain/friends_repository.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/friend_list_item.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/friends_list_empty_state.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_Profile/view/screens/friend_profile_screen.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FriendsRepository _repository = FriendsRepository();
  List<FriendListResult> friendListResult = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFriends());
  }

  Future<void> _loadFriends() async {
    final model = await _repository.getFriendList();
    if (model != null && model.success) {
      setState(() => friendListResult = model.data);
    } else {
      showSuccessOrFail(model?.message ?? L10n.current.something_went_wrong, false, context);
    }
  }

  Future<void> _unfriendUser(String friendId) async {
    final success = await _repository.unfriendUser(friendId);
    if (success) {
      await _loadFriends();
    } else {
      showSuccessOrFail(L10n.current.something_went_wrong, false, context);
    }
  }

  Future<void> _navigateToProfile(String? userId) async {
    if (userId == null) return;

    final user = await _repository.getUserDetail(userId);
    if (user != null) {
      Navigator.push(
        context,
        SlideLeftRoute(
          routeName: "/profileScreen",
          page: FriendProfileScreen(userDetail: user),
        ),
      );
    } else {
      showSuccessOrFail(L10n.current.something_went_wrong, false, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildFriendList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: NeumorphicButton(
            padding: EdgeInsets.zero,
            child: Center(child: Image.asset(AssetsConstant.leftArrowIcon)),
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
            child: GlobalWidgets.setText(
              L10n.current.friends_list_title,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              strTextColor: AppColors.strMainTextColorWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      itemCount: friendListResult.isEmpty ? 1 : friendListResult.length,
      itemBuilder: (context, index) {
        if (friendListResult.isEmpty) {
          return FriendsListEmptyState();
        }

        final friend = friendListResult[index];
        final dobStr = friend.friendDetail?.dob ?? '';
        final age = dobStr.isNotEmpty ? calculateAge(DateTime.fromMillisecondsSinceEpoch(int.parse(dobStr))) : 0;

        return FriendListItem(
          friend: friend,
          age: age,
          onTap: () => _navigateToProfile(friend.friendDetail?.sId),
          onDelete: () => _confirmUnfriend(friend.friendId),
        );
      },
    );
  }

  void _confirmUnfriend(String friendId) {
    globalWidget.showPopUpWithMessage(
      context: _scaffoldKey.currentContext ?? context,
      conditionButtonEnable: true,
      titleMessage: L10n.current.app_name,
      onPressOKButton: () => _unfriendUser(friendId),
      message: L10n.current.friends_list_remove_friend_warning_message,
    );
  }
}
