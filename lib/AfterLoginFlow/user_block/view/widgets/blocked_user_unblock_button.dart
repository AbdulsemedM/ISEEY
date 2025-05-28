import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class BlockedUserUnblockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 20, right: 10),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            child: Image.asset(
              AssetsConstant.pwdIcon,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: GlobalWidgets.setText(
              L10n.current.blocked_user_unblock_title,
              strTextColor: AppColors.strFieldShadow,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}