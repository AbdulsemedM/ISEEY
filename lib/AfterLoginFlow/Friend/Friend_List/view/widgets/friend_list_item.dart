import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/friend_avatar.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/friend_info.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/social_media_buttons.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/domain/FriendList_Model/FriendListModel.dart';
import 'package:iseey/Services/assets_constant.dart';

class FriendListItem extends StatelessWidget {
  final FriendListResult friend;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int age;

  const FriendListItem({
    required this.friend,
    required this.onTap,
    required this.onDelete,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
        child: Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            extentRatio: 0.24,
            children: [
              CustomSlidableAction(
                backgroundColor: AppColors.listBoxBackgroundColor,
                onPressed: (context) => onDelete(),
                child: Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  child: NeumorphicButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Image.asset(
                        AssetsConstant.deleteIcon,
                        fit: BoxFit.contain,
                        scale: 1.2,
                      ),
                    ),
                    onPressed: onDelete,
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: -5,
                      lightSource: LightSource.top,
                      color: AppColors.listBoxBackgroundColor,
                      border: NeumorphicBorder(
                        color: AppColors.innerShadowColor,
                        width: 2,
                      ),
                      shadowDarkColor: AppColors.innerShadowColor,
                      shadowLightColorEmboss: Colors.transparent,
                      shadowDarkColorEmboss: AppColors.innerShadowColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  FriendAvatar(imageUrl: friend.friendDetail?.image ?? ''),
                  FriendInfo(
                    firstName: friend.friendDetail?.firstName ?? '',
                    lastName: friend.friendDetail?.lastName ?? '',
                    description: friend.friendDetail?.description ?? '',
                    countryName: friend.friendDetail?.countryName ?? '',
                    age: age,
                  ),
                  SocialMediaButtons(
                    facebookURL: friend.friendDetail?.facebookURL,
                    instagramURL: friend.friendDetail?.instagramURL,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}