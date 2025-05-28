import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/TableListModel.dart';

class FriendProfileName extends StatelessWidget {
  final UserDetail userDetail;

  const FriendProfileName({
    Key? key,
    required this.userDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GlobalWidgets.setText(
        userDetail.firstName + " " + userDetail.lastName,
        strTextColor: AppColors.strMainTextColorWhite,
        fontSize: 22,
      ),
    );
  }
}
