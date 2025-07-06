import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class BlockedUserInfo extends StatelessWidget {
  final BlockedUserResult blockedUser;
  final int age;

  const BlockedUserInfo({
    required this.blockedUser,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
              child: GlobalWidgets.setText(
                "${blockedUser.userDetail?.firstName} ${blockedUser.userDetail?.lastName}",
                fontSize: 16,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Image.asset(
                    AssetsConstant.countryTemp,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: GlobalWidgets.setText(
                    L10n.current.table_user_list_user_age(age),
                    strTextColor: AppColors.strFieldShadow,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}