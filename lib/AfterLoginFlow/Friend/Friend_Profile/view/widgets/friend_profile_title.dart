import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/generated/l10n.dart';

class FriendProfileTitle extends StatelessWidget {
  const FriendProfileTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 45),
        height: 45,
        width: double.infinity,
        child: GlobalWidgets.setText(
          L10n.current.menu_profile_title,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          strTextColor: AppColors.strMainTextColorWhite,
        ),
      ),
    );
  }
}
