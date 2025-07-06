import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/view/widgets/social_button.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';

class SocialMediaButtons extends StatelessWidget {
  final String? facebookURL;
  final String? instagramURL;

  const SocialMediaButtons({this.facebookURL, this.instagramURL});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (facebookURL?.isNotEmpty ?? false)
          SocialButton(
            asset: AssetsConstant.facebook,
            url: facebookURL!,
          ),
        if ((facebookURL?.isNotEmpty ?? false) && 
            (instagramURL?.isNotEmpty ?? false))
          Container(
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
            width: 40,
            margin: EdgeInsets.symmetric(vertical: 4),
          ),
        if (instagramURL?.isNotEmpty ?? false)
          SocialButton(
            asset: AssetsConstant.instagram,
            url: instagramURL!,
          ),
      ],
    );
  }
}