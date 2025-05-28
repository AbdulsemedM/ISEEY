import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/blocked_user_repository.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_app_bar.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_empty_state.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_item.dart';

class BlockedUserScreen extends StatefulWidget {
  @override
  _BlockedUserScreenState createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<BlockedUserResult> blockedUserList = [];
  late BlockedUserRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = BlockedUserRepository(scaffoldKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBlockedUsers();
    });
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
              BlockedUserAppBar(),
              Flexible(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    itemCount: blockedUserList.isEmpty ? 1 : blockedUserList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return blockedUserList.isEmpty
                          ? BlockedUserEmptyState()
                          : BlockedUserItem(
                              blockedUser: blockedUserList[index],
                              onUnblock: (userId) => _unblockUser(userId),
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

  Future<void> _loadBlockedUsers() async {
    final x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      final users = await _repository.getBlockedUserList();
      setState(() {
        blockedUserList = users;
      });
      x.hideLoading();
    } catch (e) {
      x.hideLoading();
      showSuccessOrFail(e.toString(), false, context);
    }
  }

  Future<void> _unblockUser(String userId) async {
    final x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      final success = await _repository.unblockUser(userId, context);
      x.hideLoading();

      if (success) {
        await _loadBlockedUsers();
        showSuccessOrFail(
          "User unblocked successfully",
          true,
          context,
          
          isCustom: true,
          isTitleEnable: true,
          onCustomOkPress: () {},
        );
      }
    } catch (e) {
      x.hideLoading();
      showSuccessOrFail(e.toString(), false, context);
    }
  }
}
