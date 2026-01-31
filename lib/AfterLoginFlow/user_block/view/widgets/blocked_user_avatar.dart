import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';
import 'package:iseey/Services/assets_constant.dart';

String _imageUrl(BlockedUserResult blockedUser) =>
    (blockedUser.userDetail?.image ?? '').trim();

class BlockedUserAvatar extends StatelessWidget {
  final BlockedUserResult blockedUser;

  const BlockedUserAvatar({required this.blockedUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: _imageUrl(blockedUser).isEmpty
          ? Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                image: DecorationImage(
                  image: AssetImage(AssetsConstant.manPlaceholder),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            )
          : CachedNetworkImage(
            imageUrl: _imageUrl(blockedUser),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: HexColor("F3F3F3"),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            },
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) {
              return Container(
                height: 80,
                width: 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    image: DecorationImage(
                      image: AssetImage(AssetsConstant.manPlaceholder),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      
    );
  }
}