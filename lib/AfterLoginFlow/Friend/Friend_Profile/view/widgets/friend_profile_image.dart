import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/ImageNetwork.dart';
import 'package:iseey/Services/assets_constant.dart';

class FriendProfileImage extends StatelessWidget {
  final String profileImage;
  
  const FriendProfileImage({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: profileImage.isEmpty
          ? CircleAvatar(
              radius: 71.0,
              backgroundColor: AppColors.mainBackgroundColorOrange,
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage(
                  AssetsConstant.manPlaceholder,
                ),
                backgroundColor: AppColors.mainBackgroundColorOrange,
              ),
            )
          : CircleAvatar(
              radius: 71.0,
              backgroundColor: AppColors.mainBackgroundColorOrange,
              child: ClipOval(
                child: CircleAvatar(
                  radius: 70.0,
                  child: ImageNetwork(
                    url: profileImage,
                    fit: BoxFit.cover,
                    placeHolder: Center(
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            AssetsConstant.manPlaceholder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}