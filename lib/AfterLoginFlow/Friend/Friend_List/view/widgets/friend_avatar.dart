import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';

class FriendAvatar extends StatelessWidget {
  final String imageUrl;

  const FriendAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: HexColor("F3F3F3"),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Container(
            height: 80,
            width: 80,
            child: GFAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              maxRadius: 20,
              backgroundImage: AssetImage(AssetsConstant.manPlaceholder),
              shape: GFAvatarShape.square,
            ),
          ),
        ),
      ),
    );
  }
}