import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/assets_constant.dart';

class FriendInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String description;
  final String countryName;
  final int age;

  const FriendInfo({
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.countryName,
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
                "$firstName $lastName",
                fontSize: 16,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: GlobalWidgets.setText(
                description,
                fontSize: 12,
                maxLine: 2,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(15, 5, 5, 0),
                  child: GlobalWidgets.setText(
                    countryName,
                    fontSize: 12,
                    strTextColor: AppColors.strFieldShadow,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    AssetsConstant.countryTemp,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: GlobalWidgets.setText(
                    '$age years',
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