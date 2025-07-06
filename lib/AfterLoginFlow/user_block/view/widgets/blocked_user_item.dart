import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_avatar.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_info.dart';
import 'package:iseey/AfterLoginFlow/user_block/view/widgets/blocked_user_unblock_button.dart';

class BlockedUserItem extends StatelessWidget {
  final BlockedUserResult blockedUser;
  final Function(String) onUnblock;

  const BlockedUserItem({
    required this.blockedUser,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    String dobStr = blockedUser.userDetail?.dob ?? '';
    String dobTest = dobStr.isEmpty ? '898108200000' : dobStr;
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(dobTest));
    int age = calculateAge(dob);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        globalWidget.showPopUpWithMessage(
          context: mainTabsScaffoldKey.currentContext ?? context,
          conditionButtonEnable: true,
          isTitleEnable: false,
          onPressOKButton: () {
            onUnblock(blockedUser.userDetail?.sId ?? '');
          },
          message: L10n.current.blocked_user_unblock_user_warning_message + '?',
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
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
                BlockedUserAvatar(blockedUser: blockedUser),
                BlockedUserInfo(blockedUser: blockedUser, age: age),
                BlockedUserUnblockButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}