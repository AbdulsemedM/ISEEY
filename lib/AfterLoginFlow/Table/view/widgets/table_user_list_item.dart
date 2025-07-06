import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TableUserListItem extends StatelessWidget {
  final TableUsers user;

  const TableUserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dobStr = user.userDetail?.dob ?? '';
    final String dobTest = dobStr.isEmpty ? '898108200000' : dobStr;
    final DateTime dob = DateTime.fromMillisecondsSinceEpoch(int.parse(dobTest));
    final int age = calculateAge(dob);
    final facebookUrl = user.userDetail?.facebookUrl ?? '';
    final instagramUrl = user.userDetail?.instagramUrl ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(5),
          ),
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 80,
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: user.userDetail?.image ?? '',
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
                          child: GFAvatar(
                            backgroundColor: Colors.white.withOpacity(0.5),
                            maxRadius: 20,
                            backgroundImage: AssetImage(AssetsConstant.manPlaceholder),
                            shape: GFAvatarShape.square,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                        child: GlobalWidgets.setText(
                          "${user.userDetail?.firstName ?? ''} ${user.userDetail?.lastName ?? ''}",
                          fontSize: 16,
                          maxLine: 2,
                          strTextColor: AppColors.strMainTextColorWhite,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: GlobalWidgets.setText(
                          user.userDetail?.description ?? '',
                          fontSize: 12,
                          maxLine: 2,
                          strTextColor: AppColors.strMainTextColorWhite,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 5, left: 20, right: 5, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              child: Image.asset(
                                AssetsConstant.calendarIcon,
                                fit: BoxFit.contain,
                                color: Colors.orange,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                              child: GlobalWidgets.setText(
                                L10n.current.table_user_list_user_age(age),
                                strTextColor: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (facebookUrl.isNotEmpty)
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 10, top: 2),
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Image.asset(
                            AssetsConstant.facebook,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            height: 25,
                          ),
                        ),
                        onPressed: () => launchURL(facebookUrl),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: -5,
                          lightSource: LightSource.top,
                          color: AppColors.listBoxBackgroundColor,
                          border: NeumorphicBorder(
                            color: AppColors.innerShadowColor,
                            width: 0.1,
                          ),
                          shadowDarkColor: AppColors.innerShadowColor,
                          shadowLightColorEmboss: AppColors.innerShadowColor,
                          shadowDarkColorEmboss: AppColors.innerShadowColor,
                        ),
                      ),
                    ),
                  if (instagramUrl.isNotEmpty && facebookUrl.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 2, top: 2),
                      decoration: BoxDecoration(
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
                      width: 47,
                    ),
                  if (instagramUrl.isNotEmpty)
                    Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 10, bottom: 2),
                      alignment: Alignment.center,
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Image.asset(
                            AssetsConstant.instagram,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            height: 25,
                          ),
                        ),
                        onPressed: () => launchURL(instagramUrl),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: -5,
                          lightSource: LightSource.top,
                          color: AppColors.listBoxBackgroundColor,
                          border: NeumorphicBorder(
                            color: AppColors.innerShadowColor,
                            width: 0.1,
                          ),
                          shadowDarkColor: AppColors.innerShadowColor,
                          shadowLightColorEmboss: AppColors.innerShadowColor,
                          shadowDarkColorEmboss: AppColors.innerShadowColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}