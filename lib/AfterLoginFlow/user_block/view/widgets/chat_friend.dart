import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Services/assets_constant.dart';

class ChatFriend extends StatelessWidget {
  const ChatFriend({super.key, required this.friend});
  final ChatUserResult friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: friend.userDetail.image.isEmpty
                      ? Container(
                          height: 40,
                          width: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage(AssetsConstant.manPlaceholder),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : (friend.userDetail.image ?? '').trim().isEmpty
                          ? Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetsConstant.manPlaceholder),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                          imageUrl: (friend.userDetail.image ?? '').trim(),
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
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      AssetImage(AssetsConstant.manPlaceholder),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                      child: GlobalWidgets.setText(
                        friend.userDetail.firstName +
                            " " +
                            friend.userDetail.lastName,
                        fontSize: 16,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: GlobalWidgets.setText(
                        friend.restaurant?.name ?? '',
                        maxLine: 1,
                        fontSize: 13,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
                      child: GlobalWidgets.setText(
                        friend.lastMessage?.message ?? '',
                        maxLine: 1,
                        fontSize: 12,
                        strTextColor: AppColors.strFieldShadow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            friend.messagesCount == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      maxRadius: 16,
                      backgroundColor: Colors.red,
                      child: Text(
                        friend.messagesCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}