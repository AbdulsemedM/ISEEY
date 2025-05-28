import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/assets_constant.dart';

class TableUserItem extends StatelessWidget {
  final TableUsers user;
  final bool showDivider;

  const TableUserItem({
    Key? key,
    required this.user,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider)
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
              color: Colors.red,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.listBoxBackgroundColor,
                  AppColors.mainTextColorWhite,
                  AppColors.listBoxBackgroundColor,
                ],
              ),
            ),
            height: 1,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: GlobalWidgets.setText(
                        "${user.userDetail?.firstName ?? ''} ${user.userDetail?.lastName ?? ''}",
                        fontSize: 18,
                        maxLine: 2,
                        strTextColor: AppColors.strMainTextColorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user.userDetail?.description != null && user.userDetail?.description != '')
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GlobalWidgets.setText(
                          "${user.userDetail?.description ?? ''}",
                          fontSize: 15,
                          maxLine: 2,
                          strTextColor: AppColors.fieldShadow,
                        ),
                      ),
                    if (user.userDetail?.countryDetails?.name != null && user.userDetail?.countryDetails?.name != '')
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GlobalWidgets.setText(
                          "${user.userDetail?.countryDetails?.name ?? ''}",
                          fontSize: 14,
                          strTextColor: AppColors.fieldShadow,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              margin: EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: user.userDetail?.image ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: HexColor("F3F3F3"),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                      height: 50,
                      width: 50,
                      child: GFAvatar(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        maxRadius: 20,
                        backgroundImage: AssetImage(AssetsConstant.manPlaceholder),
                        shape: GFAvatarShape.square,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}